defmodule RSyslog.Format.RFC3164.Header do
  alias RSyslog.Format.RFC3164.Header.Timestamp
  alias RSyslog.Format.Common.Hostname

  @doc """
  Get the header data according to RFC3164. The header contains two fields: the timestamp and the
  hostname. The encoding used in the returned value is seven-bit ASCII in an eight bit field. 

  ## Returns
    -  "`header`"
  """
  def get(now) do
    [Timestamp.get(now), " ", Hostname.get(), " "]
  end
end
