defmodule NetworkTest do
  use ExUnit.Case

  alias Nnn.Network

  test "#create_neuron" do
    neuron = Network.create_neuron
    assert Process.alive? neuron
  end

  test "#connect" do
    input_neuron = Network.create_neuron
    output_neuron = Network.create_neuron
    Network.connect(input_neuron, output_neuron, 4.2)
    assert Agent.get(input_neuron, &(&1.outs)) == [output_neuron]
    assert Agent.get(output_neuron, &(&1.ins)) == [{input_neuron, 4.2}]
  end

  test "#create" do
    network = Network.init([4, 3, 2])
    assert length(network.input_layer) == 4
    assert length(network.output_layer) == 2
    input_neuron = hd(network.input_layer)
    second_layer = Agent.get(input_neuron, &(&1.outs))

    assert length(second_layer) == 3
  end

end
