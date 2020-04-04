defmodule NSyslog.Writer do
  defstruct [:protocol, :host, :port, :aid, :socket, conn_opts: [], backoff: 0]

  # Only restart the Writer if it exists abnormally
  use GenServer, restart: :transient
  require Logger

  alias __MODULE__
  alias NSyslog.Writer.{Backoff, Registry, Helpers}

  ##################
  ##### CLIENT #####
  ##################

  @doc """
  Client call to initialize a new GenServer to a given `host`:`port`.

  ## Parameters
    - `state` - initial `%Writer{}` struct, expects `:aid`, `:host`, and `:port`.
  """
  def start_link(%Writer{aid: aid} = state) do
    GenServer.start_link(__MODULE__, state, name: Registry.via_tuple(aid))
  end

  @doc """
  Client call to send a message synchronously.

  ## Parameters
    - `aid` - The account ID to send the message to. This value is looked up in the
      `Rsyslog.Writer.Registry` to find the writer's PID.
    - `message` - The message to send.
    - `facility` - The facility level to use (default: :log_alert).
    - `severity` - The severity level to use (default: :informational).
  """
  def send(aid, message, facility \\ :log_alert, severity \\ :informational) do
    GenServer.call(Registry.via_tuple(aid), {:send, message, facility, severity})
  end

  @doc """
  Client call to send a message asynchronously.

  ## Parameters
    - `aid` - The account ID to send the message to. This value is looked up in the
      `Rsyslog.Writer.Registry` to find the writer's PID.
    - `message` - The message to send
    - `facility` - The facility level to use (default: :log_alert).
    - `severity` - The severity level to use (default: :informational).
  """
  def send_async(aid, message, facility \\ :log_alert, severity \\ :informational) do
    GenServer.cast(Registry.via_tuple(aid), {:send, message, facility, severity})
  end

  ##################
  ##### SERVER #####
  ##################

  @doc """
  Server callback to initalize a new writer process. We avoid connecting to the
  host in `init/1` since it is a blocking call. We would rather let the calling process
  continue on, while the newly spawned process tries to connect to the syslog server.

  ## Parameters
    - `state` - The inital state of the `Writer`.
  """
  def init(state) do
    {:ok, state, {:continue, :syslog_connect}}
  end

  @doc """
  Server callback to finish initializing a new writer process. We let the newly spawned process
  handle connecting to the syslog server instead of blocking the caller of init/1.

  ## Parameters
    - `{host, port}` - the host:port that the `Writer` tries to connect to.
    - `state` - the `Writer`'s current state.
  """
  def handle_continue(:syslog_connect, state) do
    %{
      host: host,
      port: port,
      protocol: protocol
    } = state

    conn_opts = Map.get(state, :conn_opts, [])
    debug_host = Helpers.get_address_debug(host)

    # Try to connect to the host
    case protocol.connect(host, port, conn_opts) do
      {:ok, socket} ->
        Logger.info("Connected to #{debug_host}:#{port}")

        # Insert the socket into the writer's state and reset the backoff state
        state =
          state
          |> Map.put(:socket, socket)
          |> Map.put(:backoff, 0)

        {:noreply, state}

      {:error, reason} ->
        # If we couldn't connect, get the current backoff state and increment it by one
        {backoff_state, new_state} = Map.get_and_update(state, :backoff, fn x -> {x, x + 1} end)

        case Backoff.get(backoff_state) do
          # We timed out trying to connect to the host
          :timeout ->
            Logger.warn("Timed out trying to connect to #{debug_host}:#{port}")
            # Exit with a normal reason :shutdown
            {:stop, :shutdown, new_state}

          # Continue backing off
          backoff_sec ->
            Logger.warn("Could not connect to #{debug_host}:#{port} -- #{reason}.")
            Logger.warn("Waiting #{backoff_sec} seconds for #{debug_host}:#{port}.")
            Process.sleep(backoff_sec * 1000)

            {:noreply, new_state, {:continue, :syslog_connect}}
        end
    end
  end

  defp handle_send(message, facility, severity, %{protocol: protocol, socket: socket} = state) do
    case protocol.send(socket, message, facility, severity) do
      :ok ->
        :ok

      {:error, reason} ->
        debug_host = Helpers.get_address_debug(state.host)
        Logger.warn("Could not send message to #{debug_host}:#{state.port} -- #{reason}.")
        {:error, reason}
    end
  end

  @doc """
  Sever callback to send a message synchronously.

  ## Parameters
    - `{:send, message, facility, severity}` - the message to send.
    - `state` - the `Writer`'s current state.
  """
  def handle_call({:send, message, facility, severity}, _, state) do
    send_result = handle_send(message, facility, severity, state)

    case send_result do
      :ok -> {:reply, :ok, state}
      {:error, reason} -> {:reply, {:error, reason}, state}
    end
  end

  @doc """
  Sever callback to send a message asynchronously.

  ## Parameters
    - `{:send, message, facility, severity}` - the message to send.
    - `state` - the `Writer`'s current state.
  """
  def handle_cast({:send, message, facility, severity}, state) do
    handle_send(message, facility, severity, state)
    {:noreply, state}
  end

  defp handle_close(state) do
    debug_host = Helpers.get_address_debug(state.host)
    Logger.warn("Lost connection to #{debug_host}:#{state.port}")
    {:noreply, state, {:continue, :syslog_connect}}
  end

  @doc """
  Server callback to handle the message we get when a SSL connection is closed.

  ## Parameters
    - `{:ssl_closed, _}` - the connection down message.
    - `state` - The `Writer`'s current state.
  """
  def handle_info({:ssl_closed, _}, state) do
    handle_close(state)
  end

  @doc """
  Server callback to handle the message we get when a TCP connection is closed.

  ## Parameters
    - `{:tcp_closed, _}` - the connection down message.
    - `state` - The `Writer`'s current state.
  """
  def handle_info({:tcp_closed, _}, state) do
    handle_close(state)
  end

  @doc """
  Server callback to handle an unknown message.

  ## Parameters
    - `msg` - the mystery message.
    - `state` - the `Writer`'s current state.
  """
  def handle_info(msg, state) do
    Logger.warn("Got an unexpected message: #{msg}")
    {:noreply, state}
  end
end
