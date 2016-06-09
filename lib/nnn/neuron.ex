# Neuron data structure
defmodule Nnn.Neuron do

  use GenServer

  # Input struct : pid, weight, last value, and activation status
  defmodule Input do
    defstruct [:pid, :weight, :value, :activated]

    # Initialisation
    def new({pid, weight}), do: new(pid, weight)
    def new(pid), do: new(pid, get_random_weight)
    def new(pid, weight) do
      %__MODULE__{pid: pid, weight: weight, value: 0, activated: false}
    end

    # Activate
    def activate(input = %Input{activated: false}, value) do
      %Input{ input | value: value, activated: true }
    end

    # Clear
    def clear(input = %Input{activated: true}) do
      %Input{ input | activated: false }
    end

    defp get_random_weight, do: 2 * :random.uniform - 1
  end

  # Ins : list of inputs (struct)
  # Outs: list of PID
  defstruct ins: [], outs: []

  def new(inputs \\ []) do
    ins = inputs |> Enum.map(&Input.new/1)
    %__MODULE__{ins: ins, outs: []}
  end

  # Accept pid or {pid, weight} tuple
  def with_input(neuron, input) do
    %__MODULE__{ neuron | ins: neuron.ins ++ [Input.new(input)] }
  end

  def with_output(neuron, pid) do
    %__MODULE__{ neuron | outs: neuron.outs ++ [pid] }
  end

  defp with_cleared_ins(neuron) do
    cleared_ins = neuron.ins |> Enum.map( &Input.clear/1 )
    %__MODULE__{ neuron | ins: cleared_ins }
  end

  def evaluating(neuron, from, value) do
    ins = neuron.ins
    |> Enum.map( fn input ->
         case input do
           %Input{pid: ^from} -> input |> Input.activate(value)
           _                  -> input
         end
       end )

    %__MODULE__{ neuron | ins: ins }
  end

  def check_activation(neuron) do
    res = case Enum.all?(neuron.ins, &(&1.activated)) do
      false -> { neuron, :unactivated }
      true  -> { with_cleared_ins(neuron), { :activated, output(neuron) } }
    end
  end

  defp sigmoid(x) do
    2 / ( 1 + :math.exp(-x) ) - 1
  end

  defp output(neuron) do
    neuron.ins
    |> Enum.map( &(&1.weight * &1.value) )
    |> Enum.sum
    |> sigmoid
  end

end
