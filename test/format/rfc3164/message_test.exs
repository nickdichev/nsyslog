defmodule NSyslog.Format.RFC3164.Message.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Format.RFC3164.Message
  alias NSyslog.Format.Common.ProcessID
  import NSyslog.TestHelpers

  test "tags message" do
    pid = self() |> ProcessID.pid_to_binary()
    assert [[get_app(), "[", pid, "]", ":"], " ", "test message"] == Message.get("test message")
  end
end
