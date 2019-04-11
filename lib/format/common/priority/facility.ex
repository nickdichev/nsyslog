defmodule NSyslog.Format.Common.Priority.Facility do
  def get(:kernel), do: {:ok, 0}
  def get(:user), do: {:ok, 1}
  def get(:mail), do: {:ok, 2}
  def get(:system), do: {:ok, 3}
  def get(:security_high), do: {:ok, 4}
  def get(:syslogd), do: {:ok, 5}
  def get(:line_printer), do: {:ok, 6}
  def get(:network_news), do: {:ok, 7}
  def get(:uucp), do: {:ok, 8}
  def get(:clock_high), do: {:ok, 9}
  def get(:security_low), do: {:ok, 10}
  def get(:ftp), do: {:ok, 11}
  def get(:ntp), do: {:ok, 12}
  def get(:log_audit), do: {:ok, 13}
  def get(:log_alert), do: {:ok, 14}
  def get(:clock_low), do: {:ok, 15}
  def get(:local0), do: {:ok, 16}
  def get(:local1), do: {:ok, 17}
  def get(:local2), do: {:ok, 18}
  def get(:local3), do: {:ok, 19}
  def get(:local4), do: {:ok, 20}
  def get(:local5), do: {:ok, 21}
  def get(:local6), do: {:ok, 22}
  def get(:local7), do: {:ok, 23}
  def get(_), do: {:error, :unknown_facility}

  def validate(facility) when facility >= 0 and facility <= 23, do: :ok
  def validate(_facility), do: {:error, :facility_level}
end
