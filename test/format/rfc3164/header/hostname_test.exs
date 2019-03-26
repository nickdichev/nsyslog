defmodule RSyslog.Format.RFC3164.Header.Hostname.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC3164.Header.Hostname

  test "gets hostname" do
    {:ok, host} = :inet.gethostname()
    assert Hostname.get() == host |> to_string()
  end
end
