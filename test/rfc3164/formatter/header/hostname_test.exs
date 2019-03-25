defmodule RSyslog.RFC3164.Formatter.Header.Hostname.Test do
  use ExUnit.Case, async: true
  alias RSyslog.RFC3164.Formatter.Header.Hostname

  test "gets hostname" do
    {:ok, host} = :inet.gethostname()
    assert Hostname.get() == host |> to_string()
  end
end
