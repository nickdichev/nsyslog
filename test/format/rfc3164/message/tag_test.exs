defmodule NSyslog.Format.RFC3164.Message.Tag.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Format.RFC3164.Message.Tag
  alias NSyslog.Format.Common.ProcessID
  import NSyslog.TestHelpers

  test "get tag" do
    pid = self() |> ProcessID.pid_to_binary()
    app = get_app()
    assert [app, "[", pid, "]", ":"] == Tag.get()
  end
end
