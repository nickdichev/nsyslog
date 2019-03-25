defmodule RSyslog.RFC3164.TCP do
  alias RSyslog.RFC3164.{Formatter, Validate}

  @doc """
  Connect to a given syslog host when given a binary address.

  ## Returns
    - {:ok, socket}
    - {:error, reason}
  """
  def connect(address, port) when is_binary(address) and is_integer(port) do
    connect(String.to_charlist(address), port)
  end

  @doc """
  Connect to a given syslog host. 

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

  ## Returns
    - :ok
  """
  def close(socket) do
    :gen_tcp.close(socket)
  end

  @doc """
  Send a message over a given `socket`. The message is formatted
  according to RFC3154 before being sent.

  ## Returns
    - :ok
    - {:error, reason}
  """
  def send(socket, msg) do
    with {:ok, msg} <- Validate.initial_msg(msg),
         {:ok, msg} <- Formatter.format(msg),
         {:ok, msg} <- Validate.packet_size(msg) do
      :gen_tcp.send(socket, msg)
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
