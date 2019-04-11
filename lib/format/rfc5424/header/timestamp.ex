defmodule NSyslog.Format.RFC5424.Header.Timestamp do
  def get(nil), do: DateTime.utc_now() |> to_string()
  def get(dt), do: dt |> to_string()
end
