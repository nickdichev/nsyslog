defmodule RSyslog.Format.RFC3164.Message.Tag do
  alias RSyslog.Format.Common.{ProcessID, AppName}

  @doc """
  Generate the tag for the syslog message.

  ## Returns
    - "`tag`"
  """
  def get() do
    pid_str = self() |> ProcessID.pid_to_binary()
    [AppName.get(), "[", pid_str, "]", ":"]
  end
end
