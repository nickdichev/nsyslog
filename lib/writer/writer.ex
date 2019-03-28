defmodule RSyslog.Writer do
  defstruct host: nil, port: nil, aid: nil, socket: nil, backoff: 0

  use GenServer
  require Logger

  alias RSyslog.Writer
  alias RSyslog.Writer.Backoff

  ##################
  ##### CLIENT #####
  ##################

  @doc """
  Client call to initialize a new GenServer to a given `host`:`port`.
  """
  def start_link(%Writer{} = state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @doc """
  Client call to send a message synchronously.
  """
  def send(message) do
    pid = GenServer.whereis(__MODULE__)
    GenServer.call(pid, {:send, message})
  end

  @doc """
  Client call to send a message asynchronously.
  """
  def send_async(message) do
    pid = GenServer.whereis(__MODULE__)
    GenServer.cast(pid, {:send, message})
  end

  ##################
  ##### SERVER #####
  ##################

  @doc """
  Server callback to initalize a new writer process. We avoid connecting to the 
  host in `init/1` since it is a blocking call. We would rather let the calling process
  continue on, while the new process tries to connect to the syslog server.
  """
  def init(%Writer{host: host, port: port} = state) do
    state = Map.put(state, :socket, nil)
    {:ok, state, {:continue, {host, port}}}
  end

  @doc """
  Server callback to finish initializing a new writer process. We let the newly spawned process
  handle connecting to the syslog server instead of blocking the caller of init/1.
  """
  def handle_continue({host, port}, state) do
    # Try to connect to the host
    case RSyslog.RFC3164.TCP.connect(host, port) do
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
            # Backoff before trying to connect again
            Logger.warn("Could not connect to #{host}:#{port} -- #{reason}.")
            Logger.warn("Waiting #{backoff_sec} seconds.")
            Process.sleep(backoff_sec * 1000)

            {:noreply, new_state, {:continue, {host, port}}}
        end
    end
  end

  def handle_call({:send, message}, _, %{socket: socket} = state) do
    case RSyslog.RFC3164.TCP.send(socket, message) do
      :ok ->
        {:reply, :ok, state}

      {:error, reason} ->
        Logger.warn("Could not send message to #{state.host}:#{state.port} -- #{reason}.")
        {:reply, :error, state}
    end
  end

  def handle_cast({:send, message}, %{socket: socket} = state) do
    case RSyslog.RFC3164.TCP.send(socket, message) do
      :ok ->
        {:noreply, state}

      {:error, reason} ->
        Logger.warn("Could not send message to #{state.host}:#{state.port} -- #{reason}.")
        {:noreply, state}
    end
  end
end
