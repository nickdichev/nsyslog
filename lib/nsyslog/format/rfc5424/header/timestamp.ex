defmodule NSyslog.Format.RFC5424.Header.Timestamp do
  def get(dt), do: dt |> to_string()
end
