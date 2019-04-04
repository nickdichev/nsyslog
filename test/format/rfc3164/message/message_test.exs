defmodule RSyslog.Format.RFC3164.Message.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Message
  alias RSyslog.Format.Common.ProcessID
  import RSyslog.TestHelpers

  test "tags message" do
    pid = self() |> ProcessID.pid_to_binary()
    assert [[get_app(), "[", pid, "]", ":"], " ", "test message"] == Message.get("test message")
  end
end
