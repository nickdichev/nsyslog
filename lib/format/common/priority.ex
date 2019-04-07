defmodule RSyslog.Format.Common.Priority do
  @lt_ascii 60
  @gt_ascii 62

  defp validate_facility(facility) when facility >= 0 and facility <= 23, do: :ok
  defp validate_facility(_facility), do: {:error, :facility_level}

  defp validate_severity(severity) when severity >= 0 and severity <= 7, do: :ok
  defp validate_severity(_severity), do: {:error, :severity_level}

  defp validate_levels(facility, severity) do
    with :ok <- validate_facility(facility),
         :ok <- validate_severity(severity) do
      :ok
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp calculate_priority(facility, severity), do: facility * 8 + severity

  @doc """
  Get the priority data according to RFC3164. The encoding used in the 
  returned value is seven-bit ASCII in an eight bit field. 

  ## Parameters
    - `facility` - the facility level.
    - `severity` - the severity level.

  ## Returns
    -  "<`priority`>"
    - {:error, reason}
  """
  def get(facility, severity) do
    case validate_levels(facility, severity) do
      :ok ->
        pri_val =
          calculate_priority(facility, severity)
          |> to_charlist

        priority = [@lt_ascii, pri_val, @gt_ascii]

        {:ok, priority}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
