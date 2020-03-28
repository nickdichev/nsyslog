alias NSyslog.Writer
alias NSyslog.Writer.Supervisor

Supervisor.create_writer(%Writer{
  protocol: NSyslog.Protocol.TCP,
  aid: "1",
  host: "localhost",
  port: 514
})

Supervisor.create_writer(%Writer{
  protocol: NSyslog.Protocol.SSL,
  aid: "2",
  host: "localhost",
  port: 6514
})

possible_aids = ["1", "2"]

num_messages =
  case Enum.at(System.argv(), 0) do
    nil -> 1000
    num -> num |> String.to_integer()
  end

aid_list =
  Stream.repeatedly(fn -> Enum.random(possible_aids) end)
  |> Enum.take(num_messages)

start_time = System.monotonic_time(:second)

Task.async_stream(aid_list, Writer, :send, ["hello!"])
|> Enum.to_list()

end_time = System.monotonic_time(:second)
delta = end_time - start_time

seconds =
  case delta > 1 do
    true -> "seconds"
    false -> "second"
  end

IO.puts("Took #{delta} #{seconds} to send #{num_messages} messages.")
