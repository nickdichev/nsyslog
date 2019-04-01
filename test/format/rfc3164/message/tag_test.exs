defmodule RSyslog.Format.RFC3164.Message.Tag.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Message.Tag

  test "get tag" do
    pid = self() |> Tag.pid_to_binary()
    assert ["rsyslog", "[", pid, "]", ":"] == Tag.get()
  end
end
