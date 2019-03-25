defmodule RSyslog.RFC3164.Formatter.Header.Test do
  use ExUnit.Case, async: true
  alias RSyslog.RFC3164.Formatter.Header

  test "gets header" do
    {:ok, host} = :inet.gethostname()
    host = host |> to_string()
    regex = ~r/[Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec] \d{2} \d{2}:\d{2}:\d{2} #{host}/
    assert Regex.match?(regex, Header.get())
  end
end