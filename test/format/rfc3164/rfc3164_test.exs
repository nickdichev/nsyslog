defmodule RSyslog.RFC3164.Format.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164, as: Format
  alias RSyslog.Format.Common.{Priority, ProcessID}
  import RSyslog.TestHelpers

  test "errors on invalid facility" do
    assert Format.format("test message", -1, 3) == {:error, :facility_level}
  end

  test "errors on invalid severity" do
    assert Format.format("test message", 1, -3) == {:error, :severity_level}
  end

  test "formats valid message" do
    {:ok, pri} = Priority.get(14, 6)
    {:ok, host} = :inet.gethostname()
    host = host |> to_string()
    app = get_app()
    pid = self() |> ProcessID.pid_to_binary()

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
      pri,
      [["Apr", " ", " 1", " ", ["03", ":", "03", ":", "44"]], " ", host, " "],
      [[app, "[", pid, "]", ":"], " ", "test message"],
      "\n"
    ]

    {:ok, msg} = Format.format("test message", 14, 6, dt)
    assert expected == msg
  end
end
