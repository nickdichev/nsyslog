defmodule RSyslog.Format.RFC3164.Header.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Header

  test "gets header" do
    {:ok, host} = :inet.gethostname()
    host = host |> to_string()
    dt = %DateTime{
      day: 1,
      hour: 3,
      minute: 3,
      month: 4,
      second: 44,
      std_offset: 0,
      time_zone: "Etc/UTC",
      utc_offset: 0,
      year: 2019,
      zone_abbr: "UTC"
    }
    expected = [
      ["Apr", " ", " 1", " ", ["03", ":", "03", ":", "44"]],
      " ",
      host,
      " "
    ]

    assert expected == Header.get(dt)
  end
end
