defmodule RSyslog.Format.Common.Priority.Facility.Test do
  use ExUnit.Case, async: true
  alias RSyslog.Format.Common.Priority.Facility

  test "kernel" do
    assert Facility.get(:kernel) == {:ok, 0}
  end

  test "user" do
    assert Facility.get(:user) == {:ok, 1}
  end

  test "mail" do
    assert Facility.get(:mail) == {:ok, 2}
  end

  test "system" do
    assert Facility.get(:system) == {:ok, 3}
  end

  test "security_high" do
    assert Facility.get(:security_high) == {:ok, 4}
  end

  test "syslogd" do
    assert Facility.get(:syslogd) == {:ok, 5}
  end

  test "line_printer" do
    assert Facility.get(:line_printer) == {:ok, 6}
  end

  test "network_news" do
    assert Facility.get(:network_news) == {:ok, 7}
  end

  test "uucp" do
    assert Facility.get(:uucp) == {:ok, 8}
  end

  test "clock_high" do
    assert Facility.get(:clock_high) == {:ok, 9}
  end

  test "security_low" do
    assert Facility.get(:security_low) == {:ok, 10}
  end

  test "ftp" do
    assert Facility.get(:ftp) == {:ok, 11}
  end

  test "ntp" do
    assert Facility.get(:ntp) == {:ok, 12}
  end

  test "log_audit" do
    assert Facility.get(:log_audit) == {:ok, 13}
  end

  test "log_alert" do
    assert Facility.get(:log_alert) == {:ok, 14}
  end

  test "clock_low" do
    assert Facility.get(:clock_low) == {:ok, 15}
  end

  test "local0" do
    assert Facility.get(:local0) == {:ok, 16}
  end

  test "local1" do
    assert Facility.get(:local1) == {:ok, 17}
  end

  test "local2" do
    assert Facility.get(:local2) == {:ok, 18}
  end

  test "local3" do
    assert Facility.get(:local3) == {:ok, 19}
  end

  test "local4" do
    assert Facility.get(:local4) == {:ok, 20}
  end

  test "local5" do
    assert Facility.get(:local5) == {:ok, 21}
  end

  test "local6" do
    assert Facility.get(:local6) == {:ok, 22}
  end

  test "local7" do
    assert Facility.get(:local7) == {:ok, 23}
  end

  test "unknown" do
    assert Facility.get(:unknown) == {:error, :unknown_facility}
  end

  test "valid level" do
    assert Facility.validate(13) == :ok
  end

  test "invalid level" do
    assert Facility.validate(-1) == {:error, :facility_level}
    assert Facility.validate(24) == {:error, :facility_level}
  end
end
