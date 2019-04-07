defmodule RSyslog.Writer do
  defstruct [:rfc, :protocol, :host, :port, :aid, :socket, :connect_fun, :send_fun, backoff: 0]

  use GenServer
  require Logger

  alias __MODULE__
  alias RSyslog.Writer.{Backoff, Registry}
  alias RSyslog.Protocol.{TCP, SSL}

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
    - `facility` - The facility level to use (default: 14).
    - `severity` - The severity level to use (default: 6).
  """
  def send(aid, message, facility \\ 14, severity \\ 6) do
    GenServer.call(Registry.via_tuple(aid), {:send, message, facility, severity})
  end

  @doc """
  Client call to send a message asynchronously.

  ## Parameters
    - `aid` - The account ID to send the message to. This value is looked up in the 
      `Rsyslog.Writer.Registry` to find the writer's PID. 
    - `message` - The message to send
    - `facility` - The facility level to use (default: 14)
    - `severity` - The severity level to use (default: 6)
  """
  def send_async(aid, message, facility \\ 14, severity \\ 6) do
    GenServer.cast(Registry.via_tuple(aid), {:send, message, facility, severity})
  end

  ##################
  ##### SERVER #####
  ##################

  def get_connect_fun(rfc) do
    case rfc do
      :rfc3164 ->
        &TCP.connect/2

      :rfc5424 ->
        &SSL.connect/2
    end
  end

  def get_send_fun(rfc) do
    case rfc do
      :rfc3164 ->
        &TCP.send/4

      :rfc5424 ->
        &SSL.send/4
    end
  end

  @doc """
  Server callback to initalize a new writer process. We avoid connecting to the 
  host in `init/1` since it is a blocking call. We would rather let the calling process
  continue on, while the newly spawned process tries to connect to the syslog server.

  ## Parameters
    - `state` - The inital state of the `Writer`. 
  """
  def init(%Writer{rfc: rfc, host: host, port: port} = state) do
    # Cache the writer's connection and send functions in its state.
    state =
      state
      |> Map.put(:connect_fun, get_connect_fun(rfc))
      |> Map.put(:send_fun, get_send_fun(rfc))

    {:ok, state, {:continue, {host, port}}}
  end

  @doc """
  Server callback to finish initializing a new writer process. We let the newly spawned process
  handle connecting to the syslog server instead of blocking the caller of init/1.

  ## Parameters
    - `{host, port}` - the host:port that the `Writer` tries to connect to.
    - `state` - the `Writer`'s current state.
  """
  def handle_continue({host, port}, %Writer{connect_fun: connect} = state) do
    # Try to connect to the host
    case connect.(host, port) do
      {:ok, socket} ->
        Logger.info("Connected to #{host}:#{port}")

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
          :timeout ->
            Logger.warn("Timed out trying to connect to #{host}:#{port}")
            {:stop, :timeout, new_state}

          backoff_sec ->
            Logger.warn("Could not connect to #{host}:#{port} -- #{reason}.")
            Logger.warn("Waiting #{backoff_sec} seconds.")
            Process.sleep(backoff_sec * 1000)

            {:noreply, new_state, {:continue, {host, port}}}
        end
    end
  end

  @doc """
  Sever callback to send a message synchronously.

  ## Parameters
    - `{:send, message, facility, severity}` - the message to send.
    - `state` - the `Writer`'s current state.
  """
  def handle_call(
        {:send, message, facility, severity},
        _,
        %{send_fun: send, socket: socket} = state
      ) do
    case send.(socket, message, facility, severity) do
      :ok ->
        {:reply, :ok, state}

      {:error, reason} ->
        Logger.warn("Could not send message to #{state.host}:#{state.port} -- #{reason}.")
        {:reply, {:error, reason}, state}
    end
  end

  @doc """
  Sever callback to send a message asynchronously.

  ## Parameters
    - `{:send, message, facility, severity}` - the message to send.
    - `state` - the `Writer`'s current state.
  """
  def handle_cast({:send, message, facility, severity}, %{send_fun: send, socket: socket} = state) do
    case send.(socket, message, facility, severity) do
      :ok ->
        {:noreply, state}

      {:error, reason} ->
        Logger.warn("Could not send message to #{state.host}:#{state.port} -- #{reason}.")
        {:noreply, state}
    end
  end
end
