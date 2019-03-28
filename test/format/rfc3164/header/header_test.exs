defmodule RSyslog.Format.RFC3164.Header.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Header

  test "gets header" do
    {:ok, host} = :inet.gethostname()
    host = host |> to_string()

    regex =
      ~r/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ( \d{1}|\d{2}) \d{2}:\d{2}:\d{2} #{
        host
      }/

    assert Regex.match?(regex, Header.get())
  end
end
