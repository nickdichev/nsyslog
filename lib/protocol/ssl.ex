defmodule RSyslog.Protocol.SSL do
  alias RSyslog.Format.RFC5424

  @doc """
  Connect to a given syslog host when given a binary address.

  ## Parameters
    - `address` - host to connect to.
    - `port` - port to connect to.

  ## Returns
    - {:ok, socket}
    - {:error, reason}
  """
  def connect(address, port) when is_binary(address) and is_integer(port) do
    connect(String.to_charlist(address), port)
  end

  @doc """
  Connect to a given syslog host. 

  ## Parameters
    -  `address` - host to connect to.
    - `port` - port to connect to.

  ## Returns
    - {:ok, socket}
    - {:error,  reason}
  """
  def connect(address, port) when is_integer(port) do
    conn_opts = [
      active: false,
      keepalive: true,
      reuseaddr: true,
      send_timeout: 1000,
      send_timeout_close: true,
      certfile: Application.get_env(:rsyslog, :pemfile)
    ]

    :ssl.connect(address, port, conn_opts)
  end

  @doc """
  Close a given socket.

  ## Parameters
    - `socket` - the socket to close.

  ## Returns
    - :ok
  """
  def close(socket) do
    :ssl.close(socket)
  end

  @doc """
  Send a message over a given `socket`. The message is formatted
  according to RFC5424 before being sent.

  ## Parameters
    - `socket` - the socket which will be used to send the message.
    - `msg` - the message to send.
    - `facility` - the facility level to use.
    - `severity` - the severity level to use.

  ## Returns
    - :ok
    - {:error, reason}
  """
  def send(socket, msg, facility, severity) do
    case RFC5424.format(msg, facility, severity) do
      {:ok, msg} ->
        # Prepend the syslog message with the message length, as defined in RFC5425
        octect_len = IO.iodata_length(msg) |> to_string()
        msg = [octect_len, " ", msg]
        :ssl.send(socket, msg)

      {:error, reason} ->
        {:error, reason}
    end
  end
end
