defmodule NSyslog.Protocol do
  @type host :: :ssl.host() | :inet.socket_address() | :inet.hostname()
  @type socket :: :gen_tcp.socket() | :ssl.sslsocket()

  @callback connect(host(), pos_integer()) :: {:ok, any()} | {:error, any()}
  @callback close(socket()) :: :ok | {:error, any()}
  @callback send(socket(), iodata(), pos_integer(), pos_integer()) :: :ok | {:error, any()}
end
