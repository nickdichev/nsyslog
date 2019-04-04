defmodule RSyslog.Format.Common.ProcessID do
  def pid_to_binary(pid) when is_pid(pid) do
    pid
    |> :erlang.pid_to_list()
    |> :erlang.list_to_binary()
    |> String.trim("<")
    |> String.trim(">")
  end
end
