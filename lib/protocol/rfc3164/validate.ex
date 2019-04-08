defmodule RSyslog.Protocol.RFC3164.Validate do
  # We use byte_size since we are expecting a binary input
  def initial_msg(msg) when byte_size(msg) > 1024, do: {:error, :message_size}
  def initial_msg(msg) when byte_size(msg) > 0, do: {:ok, msg}
  def initial_msg(_msg), do: {:error, :empty_message}

  def packet_size(msg) do
    # We use IO.iodata_length since the Format functions return iolists
    case IO.iodata_length(msg) <= 1024 do
      true -> {:ok, msg}
      false -> {:error, :packet_size}
    end
  end
end
