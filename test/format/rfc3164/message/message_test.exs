defmodule RSyslog.Format.RFC3164.Message.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Message

  test "tags message" do
    assert Regex.match?(~r/rsyslog\[\d+\.\d+\.\d+\]: test message/, Message.get("test message"))
  end
end
