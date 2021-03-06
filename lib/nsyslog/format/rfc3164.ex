defmodule NSyslog.Format.RFC3164 do
  alias NSyslog.Format.Common.Priority
  alias NSyslog.Format.RFC3164.{Header, Message}

  @doc """
  Format a message according to RFC3164. The default facility level used is 14 (log alert)
  and the default severity level used is 6 (informational).

  ## Parameters
    - `msg`: the message to format
    - `facility`: the facility level used for the priority calculation (default: :log_alert)
    - `severity`: the severity level used for the priority calculation (default: :informational)
    - `now`: the DateTime which will be formatted. (default: `DateTime.utc_now/0`).

  ## Returns
    - "`formatted_message`"
    - {:error, reason}
  """
  def format(
        msg,
        facility \\ :log_alert,
        severity \\ :informational,
        datetime \\ DateTime.utc_now()
      ) do
    case Priority.get(facility, severity) do
      {:ok, priority} -> {:ok, [priority, Header.get(datetime), Message.get(msg), "\n"]}
      {:error, reason} -> {:error, reason}
    end
  end
end
