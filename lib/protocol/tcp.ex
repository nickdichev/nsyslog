defmodule RSyslog.Protocol.TCP do
  alias RSyslog.Format.{RFC3164, RFC5424}
  alias RSyslog.Protocol.RFC3164.Validate

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
  def send(:rfc3164, socket, msg, facility, severity) do
    with {:ok, msg} <- Validate.initial_msg(msg),
         {:ok, msg} <- RFC3164.format(msg, facility, severity),
         {:ok, msg} <- Validate.packet_size(msg) do
      :gen_tcp.send(socket, msg)
    else
      {:error, reason} -> {:error, reason}
    end
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
  def send(:rfc5424, socket, msg, facility, severity) do
    case RFC5424.format(msg, facility, severity) do
      {:ok, msg} -> :gen_tcp.send(socket, msg)
      {:error, reason} -> {:error, reason}
    end
  end
end