defmodule RSyslog.RFC3164.Formatter.Message do
  alias RSyslog.RFC3164.Formatter.Message.Tag

  @doc """
  Prepends a given message with a tag defined by RFC3164.

  ## Returns
    - "`message"`
  """
  def get(msg), do: Tag.get() <> " " <> msg
end
