defmodule NSyslog.Writer.Backoff do
  def get(0), do: 0
  def get(1), do: 1
  def get(2), do: 2
  def get(3), do: 5
  def get(4), do: 8
  def get(5), do: 10
  def get(_), do: :timeout
end
