defmodule NSyslog.Format.Common.Priority.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Format.Common.Priority

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

  test "valid priority levels" do
    for facility <- 1..23 do
      for severity <- 1..7 do
        priority = (facility * 8 + severity) |> Integer.to_string()
        expected = [60, priority, 62]
        assert Priority.get(facility, severity) == {:ok, expected}
      end
    end
  end

  test "valid priority format, facility=user, severity=error" do
    {:ok, pri} = Priority.get(1, 3)
    assert IO.iodata_length(pri) == 4
    assert pri == [60, "11", 62]
  end

  test "valid priority format, facility=log_audit, severity=warning" do
    {:ok, pri} = Priority.get(13, 4)
    assert IO.iodata_length(pri) == 5
    assert pri == [60, "108", 62]
  end

  test "valid priority format atom, facility=user, severity=error" do
    {:ok, pri} = Priority.get(:user, :error)
    assert IO.iodata_length(pri) == 4
    assert pri == [60, "11", 62]
  end

  test "invalid priority format atom (facility)" do
    assert Priority.get(:unknown, :error) == {:error, :unknown_facility}
  end

  test "invalid priority format atom (severity)" do
    assert Priority.get(:kernel, :unknown) == {:error, :unknown_severity}
  end
end
