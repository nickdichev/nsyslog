defmodule RSyslog.Format.RFC5424.Header do
  alias RSyslog.Format.Common.{Priority, Hostname, AppName, ProcessID}
  alias RSyslog.Format.RFC5424.Header.Timestamp

  @syslog_version 1

  def get(facility, severity, now, msgid) do
    case Priority.get(facility, severity) do
      {:ok, priority} ->
        {:ok, [
          priority,
          @syslog_version,
          " ",
          Timestamp.get(now),
          Hostname.get(),
          " ",
          AppName.get(),
          " ",
          ProcessID.pid_to_binary(self()),
          " ",
          msgid
        ]}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
