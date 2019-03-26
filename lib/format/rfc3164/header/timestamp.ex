defmodule RSyslog.Format.RFC3164.Header.Timestamp do
  defp get_month(1), do: "Jan"
  defp get_month(2), do: "Feb"
  defp get_month(3), do: "Mar"
  defp get_month(4), do: "Apr"
  defp get_month(5), do: "May"
  defp get_month(6), do: "Jun"
  defp get_month(7), do: "Jul"
  defp get_month(8), do: "Aug"
  defp get_month(9), do: "Sep"
  defp get_month(10), do: "Oct"
  defp get_month(11), do: "Nov"
  defp get_month(12), do: "Dec"

  def get_day(dt_day) do
    # The day needs to be padded with leading spaces, eg: " 7"
    dt_day
    |> to_string()
    |> String.pad_leading(2, " ")
  end

  def format_time(dt_value) do
    # The time needs for be padded with leading 0's, eg: "02"
    dt_value
    |> to_string()
    |> String.pad_leading(2, "0")
  end

  def get_time(%{hour: hour, minute: minute, second: second} = _datetime) do
    hour = hour |> format_time()
    minute = minute |> format_time()
    second = second |> format_time()
    hour <> ":" <> minute <> ":" <> second
  end

  defp format(datetime) do
    get_month(datetime.month) <> " " <> get_day(datetime.day) <> " " <> get_time(datetime)
  end

  @doc """
  Generates a timestamp for a syslog message.

  ## Returns
    - "`timestamp`"
  """
  def get() do
    DateTime.utc_now()
    |> format()
  end
end
