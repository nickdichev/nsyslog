defmodule NSyslog.Format.Common.AppName.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Format.Common.AppName
  import NSyslog.TestHelpers

  test "gets app name" do
    assert get_app() == AppName.get()
  end
end
