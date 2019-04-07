defmodule RSyslog.Format.Common.Priority.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.Common.Priority

  test "invalid facility level (lt 0)" do
    assert Priority.get(-1, 4) == {:error, :facility_level}
  end

  test "invalid facility level (gt 23)" do
    assert Priority.get(24, 1) == {:error, :facility_level}
  end

  test "invalid severity level (lt 0)" do
    assert Priority.get(1, -1) == {:error, :severity_level}
  end

  test "invalid severity level (gt 7)" do
    assert Priority.get(1, 8) == {:error, :severity_level}
  end

  test "valid priority format" do
    {:ok, pri} = Priority.get(1, 3)
    assert IO.iodata_length(pri) == 4
    assert pri == [60, '11', 62]

    {:ok, pri} = Priority.get(13, 4)
    assert IO.iodata_length(pri) == 5
    assert pri == [60, '108', 62]
  end
end
