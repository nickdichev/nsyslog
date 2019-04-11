alias NSyslog.Writer
alias NSyslog.Writer.Supervisor

Supervisor.create_writer(%Writer{rfc: :rfc3164, protocol: :tcp, aid: "ESS1", host: "localhost", port: 514})
Supervisor.create_writer(%Writer{rfc: :rfc3164, protocol: :tcp, aid: "ESS2", host: "localhost", port: 514})
Supervisor.create_writer(%Writer{rfc: :rfc3164, protocol: :tcp, aid: "ESS3", host: "localhost", port: 514})

possible_aids = ["ESS1", "ESS2", "ESS3"]

num_messages = 
  case Enum.at(System.argv, 0) do
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

IO.puts("Took #{delta} seconds to send #{num_messages} messages.")