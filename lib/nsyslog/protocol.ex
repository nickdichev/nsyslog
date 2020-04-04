defmodule NSyslog.Protocol do
  @type host :: :ssl.host() | :inet.socket_address() | :inet.hostname()
  @type socket :: :gen_tcp.socket() | :ssl.sslsocket()
  @type facility :: pos_integer() | atom()
  @type severity :: pos_integer() | atom()
  @type conn_opts :: [:ssl.tls_client_option()] | [:gen_tcp.connct_option()]

  @callback connect(host(), pos_integer(), conn_opts()) :: {:ok, any()} | {:error, any()}
  @callback close(socket()) :: :ok | {:error, any()}
  @callback send(socket(), iodata(), facility(), severity()) :: :ok | {:error, any()}
end
