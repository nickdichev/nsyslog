defmodule RSyslog.RFC3164.Formatter do
  alias RSyslog.RFC3164.Formatter.{Priority, Header, Message}

  @doc """
  Format a message according to RFC3164. The default facility level used is 14 (log alert)
  and the default severity level used is 6 (informational).

  ## Parameters
    - `msg`: the message to format
    - `facility`: the facility level used for the priority calculation (default: 14)
    - `severity`: the severity level used for the priority calculation (default: 6)

  ## Returns
    - "`formatted_message`"
    - {:error, reason}
  """
  def format(msg, facility \\ 14, severity \\ 6) do
    with {:ok, priority} <- Priority.get(facility, severity) do
      {:ok, priority <> Header.get() <> Message.get(msg) <> "\n"}
    else
      {:error, reason} -> {:error, reason}
    end
  end
end
