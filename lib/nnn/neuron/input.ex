# Input struct : pid, weight, last value, and activation status
defmodule Nnn.Neuron.Input do
  defstruct [:pid, :weight, :value, :activated]

  # Initialisation
  def new({pid, weight}), do: new(pid, weight)
  def new(pid), do: new(pid, get_random_weight)
  def new(pid, weight) do
    %__MODULE__{pid: pid, weight: weight, value: 0, activated: false}
  end

  # Activate
  def activate(input = %__MODULE__{activated: false}, value) do
    %__MODULE__{ input | value: value, activated: true }
  end

  # Clear
  def clear(input = %__MODULE__{activated: true}) do
    %__MODULE__{ input | activated: false }
  end

  defp get_random_weight, do: 2 * :random.uniform - 1
end
