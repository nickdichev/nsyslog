defmodule RSyslog.Format.RFC5424 do
  alias RSyslog.Format.RFC5424.{Header, StructuredData, Message}

  @doc """
  Format a message according to RFC5424. The default facility level used is 14 (log alert)
  and the default severity level used is 6 (informational).

  ## Parameters
    - `msg`: the message to format
    - `facility`: the facility level used for the priority calculation (default: 14)
    - `severity`: the severity level used for the priority calculation (default: 6)
    - `now`: the DateTime which will be formatted. (default: `nil`, gets converted to utc_now/0).
    - `msgid`: the message identifier, eg: "TCPOUT" (default: `-`)

  ## Returns
    - "`formatted_message`"
    - {:error, reason}
  """
  def message(msg, facility \\ 14, severity \\ 6, now \\ nil, msgid \\ "-") do
    case Header.get(facility, severity, now, msgid) do
      {:ok, header} -> {:ok, [header, " ", StructuredData.get(nil), " ", Message.get(msg), "\n"]}
      {:error, reason} -> {:error, reason}
    end
  end
end
