defmodule NSyslog.Protocol.TCP do
  alias NSyslog.Format.RFC3164
  alias NSyslog.Protocol.RFC3164.Validate

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
      # Use active: :once to get a :tcp_closed message if the connection is closed
      active: :once,
      keepalive: true,
      reuseaddr: true,
      send_timeout: 1000,
      send_timeout_close: true
    ]

    :gen_tcp.connect(address, port, conn_opts)
  end

  @doc """
  Close a given socket.

  ## Parameters
    - `socket` - the socket to close.

  ## Returns
    - :ok
  """
  def close(socket) do
    :gen_tcp.close(socket)
  end

  @doc """
  Send a message over a given `socket`. The message is formatted
  according to RFC3154 before being sent.

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
    with {:ok, msg} <- Validate.initial_msg(msg),
         {:ok, msg} <- RFC3164.format(msg, facility, severity),
         {:ok, msg} <- Validate.packet_size(msg) do
      :gen_tcp.send(socket, msg)
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
