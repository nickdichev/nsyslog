defmodule RSyslog.Format.RFC3164.Header.Hostname do
  @doc """
  Get the hostname of the system sending the syslog message.

  ## Returns
    - "`hostname`"
  """
  def get() do
    case :inet.gethostname() do
      {:ok, hostname} -> hostname |> to_string()
    end
  end
end
