defmodule RSyslog.RFC3164.Formatter.Header.Timestamp.Test do
  use ExUnit.Case, async: true
  alias RSyslog.RFC3164.Formatter.Header.Timestamp

  test "gets timestamp" do
    regex = ~r/[Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec] \d{2} \d{2}:\d{2}:\d{2}/
    assert Regex.match?(regex, Timestamp.get())
  end
end