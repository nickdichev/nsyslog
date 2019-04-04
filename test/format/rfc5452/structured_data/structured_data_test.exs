defmodule RSyslog.Format.RFC5424.StructuredData.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.RFC5424.StructuredData

  test "gets nilvalue" do
    assert "-" == StructuredData.get(nil)
  end
end