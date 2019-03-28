defmodule RSyslog.Writer.Registry do
  @doc """
  Function called by `child_spec/1` to start the Registry
  """
  def start_link() do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  @doc """
  Callback the `RSyslog.Application` supervisor calls to start the writer registry.
  """
  def child_spec(_) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end

  def via_tuple(aid) do
    # Register this writer in `:writer_registry` under the name {__MODULE__, aid}
    # so we can lookup the pid for this writer with `aid` when its time to send.
    {:via, Registry, {__MODULE__, aid}}
  end
end
