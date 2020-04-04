defmodule NSyslog.Format.Common.Hostname do
  @doc """
  Get the hostname of the system sending the syslog message.

  ## Returns
    - "`hostname`"
  """
  def get() do
    {:ok, hostname} = :inet.gethostname()
    hostname
  end
end
