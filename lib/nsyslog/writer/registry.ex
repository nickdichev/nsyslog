defmodule NSyslog.Writer.Registry do
  @doc """
  Function called by `child_spec/1` to start the Registry
  """
  def start_link() do
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  @doc """
  Callback the `NSyslog.Application` supervisor calls to start the writer registry.
  """
  def child_spec(_args) do
    Supervisor.child_spec(
      Registry,
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    )
  end

  @doc """
  Get the via tuple for a given account ID. 
  """
  def via_tuple(aid) do
    # Register this writer in `:writer_registry` under the name {__MODULE__, aid}
    # so we can lookup the pid for this writer with `aid` when its time to send.
    {:via, Registry, {__MODULE__, aid}}
  end

  @doc """
  Lookup if a `NSyslog.Writer` exists for the given account ID. 

  ## Parameters
    - `aid`: the account ID to lookup

  ## Returns
    - `[{pid, _}] if a Writer exists
    - [] if a writer does not exist
  """
  def lookup(aid) do
    Registry.lookup(__MODULE__, aid)
  end
end
