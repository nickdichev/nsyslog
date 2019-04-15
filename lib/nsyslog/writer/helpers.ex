defmodule NSyslog.Writer.Helpers do
  alias NSyslog.Protocol.{TCP, SSL}

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

  @doc """
  Helper function to get the connecting function this `Writer` should use.
  The determination is based off the RFC this writer will be using. 

  ## Parameters
    - `rfc` - the RFC this writer is expected to adhere to.
  """
  def get_connect_fun(rfc) do
    case rfc do
      :rfc3164 ->
        &TCP.connect/2

      :rfc5424 ->
        &SSL.connect/2
    end
  end

  @doc """
  Helper function to get the sending function this `Writer` should use.
  The determination is based off the RFC this writer will be using. 

  ## Parameters
    - `rfc` - the RFC this writer is expected to adhere to.
  """
  def get_send_fun(rfc) do
    case rfc do
      :rfc3164 ->
        &TCP.send/4

      :rfc5424 ->
        &SSL.send/4
    end
  end
end
