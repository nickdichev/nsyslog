defmodule NSyslog.Format.RFC5424.StructuredData do
  @doc """
  Generate structure data. For now, we just return NILVALUE.
  """
  def get(nil), do: "-"
end
