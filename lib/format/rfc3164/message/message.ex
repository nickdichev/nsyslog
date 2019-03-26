defmodule RSyslog.Format.RFC3164.Message do
  alias RSyslog.Format.RFC3164.Message.Tag

  @doc """
  Prepends a given message with a tag defined by RFC3164.

  ## Returns
    - "`message"`
  """
  def get(msg), do: Tag.get() <> " " <> msg
end
