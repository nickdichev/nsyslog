defmodule RSyslog.RFC3164.Formatter.Message.Tag.Test do
  use ExUnit.Case, async: true
  alias RSyslog.RFC3164.Formatter.Message.Tag

  test "get tag" do
    assert Regex.match?(~r/rsyslog\[\d+\.\d+\.\d+\]/, Tag.get())
  end
end
