defmodule RSyslog.Format.Common.Priority.Severity do
  def get(:emergency), do: {:ok, 0}
  def get(:alert), do: {:ok, 1}
  def get(:critical), do: {:ok, 2}
  def get(:error), do: {:ok, 3}
  def get(:warning), do: {:ok, 4}
  def get(:notice), do: {:ok, 5}
  def get(:informational), do: {:ok, 6}
  def get(:debug), do: {:ok, 7}
  def get(_), do: {:error, :unknown_severity}
end
