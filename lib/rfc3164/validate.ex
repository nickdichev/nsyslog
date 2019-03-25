defmodule RSyslog.RFC3164.Validate do
  
  def initial_msg(msg) when byte_size(msg) > 0, do: {:ok, msg}
  def initial_msg(_msg), do: {:error, :empty_message}

  def packet_size(msg) when byte_size(msg) <= 1024, do: {:ok, msg}
  def packet_size(_msg), do: {:error, :packet_size}
end