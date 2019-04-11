defmodule NSyslog.Format.Common.ProcessID.Test do
  use ExUnit.Case, async: true

  alias NSyslog.Format.Common.ProcessID

  test "formats pid" do
    assert Regex.match?(~r/^[0-9]+\.[0-9]+\.[0-9]+$/, ProcessID.pid_to_binary(self()))
  end
end
