defmodule NSyslog.Format.RFC5424.StructuredData.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Format.RFC5424.StructuredData

  test "gets nilvalue" do
    assert "-" == StructuredData.get(nil)
  end
end
