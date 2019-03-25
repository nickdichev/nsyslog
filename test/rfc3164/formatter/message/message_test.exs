defmodule RSyslog.RFC3164.Formatter.Message.Test do
  use ExUnit.Case, async: true
  alias RSyslog.RFC3164.Formatter.Message

  test "tags message" do
    assert Regex.match?(~r/rsyslog\[\d+\.\d+\.\d+\]: test message/, Message.get("test message"))
  end
end
