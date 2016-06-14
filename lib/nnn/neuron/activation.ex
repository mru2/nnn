defmodule Nnn.Neuron.Activation do

  alias Nnn.Neuron
  alias Nnn.Neuron.Input

  def activated?(neuron), do: Enum.all?(neuron.ins, &(&1.activated))

  def cleared(neuron) do
    cleared_ins = neuron.ins |> Enum.map( &Input.clear/1 )
    %Neuron{ neuron | ins: cleared_ins }
  end

  def output(neuron) do
    total_in = neuron.ins |> Enum.map( &(&1.weight * &1.value) ) |> Enum.sum
    sigmoid(total_in + neuron.bias)
  end

  # 0 to 1 sigmoid
  def sigmoid(x) do
    1 / ( 1 + :math.exp(-x) )
  end

end
