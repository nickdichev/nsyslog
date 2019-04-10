defmodule RSyslog.Format.Common.Priority do
  @lt_ascii 60
  @gt_ascii 62

  alias RSyslog.Format.Common.Priority.{Severity, Facility}

  defp validate(facility, severity) do
    with :ok <- Facility.validate(facility),
         :ok <- Severity.validate(severity) do
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp calculate_priority(facility, severity), do: facility * 8 + severity

  @doc """
  Get the priority data for a facility and severity level. The encoding used in the 
  returned value is seven-bit ASCII in an eight bit field. 

  ## Parameters
    - `facility` - the facility level as an atom.
    - `severity` - the severity level as an atom.

  ## Returns
    -  "<`priority`>"
    - {:error, reason}
  """
  def get(facility, severity) when is_atom(facility) and is_atom(severity) do
    with {:ok, facility} <- Facility.get(facility),
         {:ok, severity} <- Severity.get(severity) do
      get(facility, severity)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Get the priority data for a facility and severity level. The encoding used in the 
  returned value is seven-bit ASCII in an eight bit field. 

  ## Parameters
    - `facility` - the facility level.
    - `severity` - the severity level.

  ## Returns
    -  "<`priority`>"
    - {:error, reason}
  """
  def get(facility, severity) when is_integer(facility) and is_integer(facility) do
    case validate(facility, severity) do
      :ok ->
        priority =
          calculate_priority(facility, severity)
          |> Integer.to_string()

        priority =
          <<@lt_ascii::size(8)>> <>
            priority <>
            <<@gt_ascii::size(8)>>

        {:ok, priority}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
