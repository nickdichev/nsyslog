defmodule RSyslog.RFC3164.Formatter.Message.Tag do
  defp pid_to_binary(pid) when is_pid(pid) do
    pid
    |> :erlang.pid_to_list()
    |> :erlang.list_to_binary()
    |> String.trim("<")
    |> String.trim(">")
  end

  @doc """
  Generate the tag for the syslog message.

  ## Returns
    - "`tag`"
  """
  def get() do
    app_name =
      case :application.get_application(__MODULE__) do
        {:ok, application} -> application |> to_string()
        :undefined -> "rsyslog"
      end

    app_name <> "[" <> pid_to_binary(self()) <> "]" <> ":"
  end
end
