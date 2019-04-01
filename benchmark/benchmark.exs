alias RSyslog.Writer
alias RSyslog.Writer.Supervisor

Supervisor.create_writer(%Writer{aid: "ESS1", host: "localhost", port: 514})
Supervisor.create_writer(%Writer{aid: "ESS2", host: "localhost", port: 514})
Supervisor.create_writer(%Writer{aid: "ESS3", host: "localhost", port: 514})

possible_aids = ["ESS1", "ESS2", "ESS3"]

aid_list = 
  Stream.repeatedly(fn -> Enum.random(possible_aids) end)
  |> Enum.take(10000)

start_time = DateTime.utc_now()

Task.async_stream(aid_list, Writer, :send, ["hello!"])
|> Enum.to_list()

end_time = DateTime.utc_now()

DateTime.diff(end_time, start_time)
|> IO.puts()