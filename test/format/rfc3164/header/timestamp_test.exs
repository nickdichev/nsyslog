defmodule RSyslog.Format.RFC3164.Header.Timestamp.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Header.Timestamp

  test "gets timestamp" do
    regex = ~r/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) \d{2} \d{2}:\d{2}:\d{2}/
    assert Regex.match?(regex, Timestamp.get())
  end
end
