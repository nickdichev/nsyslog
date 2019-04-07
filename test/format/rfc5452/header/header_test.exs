defmodule RSyslog.Format.RFC5424.Header.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC5424.Header
  alias RSyslog.Format.Common.{Priority, ProcessID}
  import RSyslog.TestHelpers

  test "gets header" do
    {:ok, pri} = Priority.get(14, 6)
    {:ok, host} = :inet.gethostname()
    host = host |> to_string()
    pid = self() |> ProcessID.pid_to_binary()
    app = get_app()

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

    expected = [pri, 1, " ", "2019-04-01 03:03:44Z", " ", host, " ", app, " ", pid, " ", "-"]

    {:ok, ret} = Header.get(14, 6, dt, "-")
    assert expected == ret
  end
end
