defmodule NSyslog.Format.Common.Hostname do
  @doc """
  Get the hostname of the system sending the syslog message.

  ## Returns
    - "`hostname`"
  """
  def get() do
    case :inet.gethostname() do
      {:ok, hostname} -> hostname |> to_string()
      {:error, _} -> "-"
    end
  end
end
