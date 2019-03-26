defmodule RSyslog.RFC3164.Format.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164, as: Format
  alias RSyslog.Format.Common.Priority

  test "errors on invalid facility" do
    assert Format.message("test message", -1, 3) == {:error, :facility_level}
  end

  test "errors on invalid severity" do
    assert Format.message("test message", 1, -3) == {:error, :severity_level}
  end

  test "formats valid message" do
    {:ok, msg} = Format.message("test message")
    {:ok, pri} = Priority.get(14, 6)
    {:ok, host} = :inet.gethostname()
    host = host |> to_string()
    app = "rsyslog"

    regex =
      ~r/#{pri}(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ( \d{1}|\d{2}) \d{2}:\d{2}:\d{2} #{host} #{
        app
      }\[\d+\.\d+\.\d+\]:/

    assert Regex.match?(regex, msg)
  end
end
