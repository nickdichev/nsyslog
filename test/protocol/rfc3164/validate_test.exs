defmodule NSyslog.Protocol.RFC3164.Validate.Test do
  use ExUnit.Case, async: true
  alias NSyslog.Protocol.RFC3164.Validate

  test "valid initial message" do
    assert Validate.initial_msg("test message") == {:ok, "test message"}
  end

  test "invalid inital message (size)" do
    invalid_msg = String.duplicate("a", 1025)
    assert Validate.initial_msg(invalid_msg) == {:error, :message_size}
  end

  test "invalid initial message (empty)" do
    assert Validate.initial_msg("") == {:error, :empty_message}
  end

  test "valid packet size" do
    packet = "<14>Mar 25 02:48:44 spooky-mac nsyslog[0.131.0]: test message"
    assert Validate.packet_size(packet) == {:ok, packet}
  end

  test "invalid packet size" do
    packet = "<14>Mar 25 02:48:44 spooky-mac nsyslog[0.131.0]: " <> String.duplicate("a", 1000)
    assert Validate.packet_size(packet) == {:error, :packet_size}
  end
end
