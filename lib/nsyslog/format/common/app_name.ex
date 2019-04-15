defmodule NSyslog.Format.Common.AppName do
  def get() do
    case :application.get_application(__MODULE__) do
      {:ok, application} -> application |> to_string()
      :undefined -> "-"
    end
  end
end
