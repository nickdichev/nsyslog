defmodule RSyslog.Application do
  use Application

  def start(_type, _args) do
    children = [
      RSyslog.Writer.Registry,
      RSyslog.Writer.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
