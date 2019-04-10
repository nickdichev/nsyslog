defmodule RSyslog.Format.Common.Priority.Severity.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.Common.Priority.Severity

  test "emergency" do
    assert Severity.get(:emergency) == {:ok, 0}
  end

  test "alert" do
    assert Severity.get(:alert) == {:ok, 1}
  end

  test "critical" do
    assert Severity.get(:critical) == {:ok, 2}
  end

  test "error" do
    assert Severity.get(:error) == {:ok, 3}
  end

  test "warning" do
    assert Severity.get(:warning) == {:ok, 4}
  end

  test "notice" do
    assert Severity.get(:notice) == {:ok, 5}
  end

  test "informational" do
    assert Severity.get(:informational) == {:ok, 6}
  end

  test "debug" do
    assert Severity.get(:debug) == {:ok, 7}
  end

  test "unknown" do
    assert Severity.get(:unknown) == {:error, :unknown_severity}
  end
  
  test "valid level" do
    assert Severity.validate(3) == :ok
  end

  test "invalid level" do
    assert Severity.validate(-1) == {:error, :severity_level}
    assert Severity.validate(8) == {:error, :severity_level}
  end
end
