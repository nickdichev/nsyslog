defmodule RSyslog.Writer.Supervisor do
  use DynamicSupervisor

  alias RSyslog.Writer

  def start_link(args) do
    DynamicSupervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def create_writer(%Writer{rfc: _, protocol: _, aid: _, host: _, port: _} = state) do
    DynamicSupervisor.start_child(__MODULE__, {Writer, state})
  end
end
