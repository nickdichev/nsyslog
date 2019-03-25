defmodule RSyslog.RFC3164.Formatter.Header do
  alias RSyslog.RFC3164.Formatter.Header.{Hostname, Timestamp}

  @doc """
  Get the header data according to RFC3164. The header contains two fields: the timestamp and the
  hostname. The encoding used in the returned value is seven-bit ASCII in an eight bit field. 

  ## Returns
    -  "`header`"
  """
  def get() do
    Timestamp.get() <> " " <> Hostname.get() <> " "
  end
end
