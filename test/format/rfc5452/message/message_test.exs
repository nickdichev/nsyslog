defmodule RSyslog.Format.RFC5424.Message.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC5424.Message

  test "formats message" do
    assert "hello" == Message.get("hello")
  end
end
