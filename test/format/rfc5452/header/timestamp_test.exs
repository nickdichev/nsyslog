defmodule NSyslog.Format.RFC5424.Header.Timestamp.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Format.RFC5424.Header.Timestamp

  test "formats timestamp" do
    dt = DateTime.utc_now()
    assert dt |> to_string == Timestamp.get(dt)
  end
end
