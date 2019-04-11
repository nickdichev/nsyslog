defmodule NSyslog.Format.RFC3164.Header.Timestamp.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Format.RFC3164.Header.Timestamp

  test "gets timestamp" do
    dt = %DateTime{
      day: 1,
      hour: 3,
      minute: 30,
      month: 4,
      second: 44,
      std_offset: 0,
      time_zone: "Etc/UTC",
      utc_offset: 0,
      year: 2019,
      zone_abbr: "UTC"
    }

    assert ["Apr", " ", " 1", " ", ["03", ":", "30", ":", "44"]] == Timestamp.get(dt)
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
    assert Timestamp.get_time(mock_datetime) == ["07", ":", "02", ":", "32"]
  end
end
