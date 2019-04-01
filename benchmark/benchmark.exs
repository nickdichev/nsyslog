alias RSyslog.Writer
alias RSyslog.Writer.Supervisor

Supervisor.create_writer(%Writer{aid: "ESS1", host: "localhost", port: 514})

start_time = DateTime.utc_now()

for _ <- 1..10000 do
  Task.async(Writer, :send, ["ESS1", "hello!"])
  |> Task.await()
end

end_time = DateTime.utc_now()

DateTime.diff(end_time, start_time)
|> IO.puts()