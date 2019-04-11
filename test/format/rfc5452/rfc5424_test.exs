defmodule NSyslog.RFC5424.Format.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Format.RFC5424, as: Format
  alias NSyslog.Format.Common.{Priority, ProcessID}
  import NSyslog.TestHelpers

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
      [
        pri,
        1,
        " ",
        "2019-04-01 03:03:44Z",
        " ",
        host,
        " ",
        app,
        " ",
        pid,
        " ",
        "-"
      ],
      " ",
      "-",
      " ",
      "test message",
      "\n"
    ]

    {:ok, msg} = Format.format("test message", 14, 6, dt, "-")
    assert expected == msg
  end
end
