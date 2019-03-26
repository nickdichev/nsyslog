defmodule RSyslog.Format.RFC3164.Header.Timestamp.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Header.Timestamp

  test "gets timestamp" do
    regex = ~r/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ( \d{1}|\d{2}) \d{2}:\d{2}:\d{2}/
    assert Regex.match?(regex, Timestamp.get())
  end

  test "pads day with leading spaces" do
    assert Timestamp.get_day("7") == " 7"
  end

  test "doesn't pad day" do
    assert Timestamp.get_day("03") == "03"
  end

  test "pads time with leading zero" do
    assert Timestamp.format_time("7") == "07"
  end

  test "doesn't pad time" do
    assert Timestamp.format_time("13") == "13"
  end

  test "formats time correctly" do
    mock_datetime = %{hour: 7, minute: 2, second: 32}
    assert Timestamp.get_time(mock_datetime) == "07:02:32"
  end
end
