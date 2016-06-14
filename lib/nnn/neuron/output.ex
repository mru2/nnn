# Output struct
defmodule Nnn.Neuron.Output do
  defstruct [:pid, :error]

  def new(pid), do: %__MODULE__{pid: pid, error: nil}

  # Correct
  def correct(output, error), do: %__MODULE__{ output | error: error }

  # Clear
  def clear(output), do: %__MODULE__{ output | error: nil }
end
