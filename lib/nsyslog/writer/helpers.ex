defmodule NSyslog.Writer.Helpers do
  @doc """
  Get a formatted string for this `Writer`'s host address.

  ## Parameters
    - `address`: the address to be formatted
  """
  def get_address_debug(address) do
    case address do
      # Format an ipv4 address
      {o1, o2, o3, o4} ->
        "#{o1}.#{o2}.#{o3}.#{o4}"

      # Format an ipv6 address
      {o1, o2, o3, o4, o5, o6, o7, o8} ->
        "#{o1}:#{o2}:#{o3}:#{o4}:#{o5}:#{o6}:#{o7}:#{o8}"

      _ ->
        address
    end
  end
end
