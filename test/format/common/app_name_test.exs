defmodule RSyslog.Format.Common.AppName.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.Common.AppName
  import RSyslog.TestHelpers

  test "gets app name" do
    assert get_app() == AppName.get()
  end
end
