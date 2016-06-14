# Neuron data structure
defmodule Nnn.Neuron do

  alias Nnn.Neuron.Input
  alias Nnn.Neuron.Output

  # Ins : list of inputs (struct)
  # Outs: list of PID
  defstruct ins: [], outs: [], learning_rate: 0.1, bias: 0

  def new(inputs \\ [], learning_rate \\ 0.1) do
    ins = inputs |> Enum.map(&Input.new/1)
    %__MODULE__{ins: ins, outs: [], learning_rate: learning_rate}
  end

  # Accept pid or {pid, weight} tuple
  def with_input(neuron, input) do
    %__MODULE__{ neuron | ins: neuron.ins ++ [Input.new(input)] }
  end

  def with_output(neuron, pid) do
    %__MODULE__{ neuron | outs: neuron.outs ++ [Output.new(pid)] }
  end

  def with_bias(neuron, bias) do
    %__MODULE__{ neuron | bias: bias }
  end

  # Activation
  def with_activation(neuron, from, value) do
    ins = neuron.ins
    |> Enum.map( fn
         input = %Input{pid: ^from} -> input |> Input.activate(value)
         input                      -> input
       end )

    %__MODULE__{ neuron | ins: ins }
  end

  # Training
  def with_correction(neuron, from, error) do
    outs = neuron.outs
    |> Enum.map( fn
         output = %Output{pid: ^from} -> output |> Output.correct(error)
         output                       -> output
       end )

    %__MODULE__{ neuron | outs: outs }
  end

end
