defmodule RSyslog.Format.Common.Hostname.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.Common.Hostname

  test "gets hostname" do
    {:ok, host} = :inet.gethostname()
    assert Hostname.get() == host |> to_string()
  end
end
