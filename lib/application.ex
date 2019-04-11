defmodule NSyslog.Application do
  use Application

  def start(_type, _args) do
    children = [
      NSyslog.Writer.Registry,
      NSyslog.Writer.Supervisor
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
