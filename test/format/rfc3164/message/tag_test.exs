defmodule RSyslog.Format.RFC3164.Message.Tag.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Message.Tag

  test "get tag" do
    assert Regex.match?(~r/rsyslog\[\d+\.\d+\.\d+\]/, Tag.get())
  end
end
