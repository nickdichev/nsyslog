defmodule RSyslog.Format.RFC3164.Message.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Message

  test "tags message" do
    pid = self() |> Message.Tag.pid_to_binary()
    assert [["rsyslog", "[", pid, "]", ":"], " ", "test message"] == Message.get("test message")
  end
end
