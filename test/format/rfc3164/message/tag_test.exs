defmodule RSyslog.Format.RFC3164.Message.Tag.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Message.Tag
  alias RSyslog.Format.Common.ProcessID
  import RSyslog.TestHelpers

  test "get tag" do
    pid = self() |> ProcessID.pid_to_binary()
    app = get_app()
    assert [app, "[", pid, "]", ":"] == Tag.get()
  end
end
