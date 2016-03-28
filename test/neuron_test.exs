defmodule NeuronTest do
  use ExUnit.Case

  alias Nnn.Neuron

  test "#init" do
    neuron = Neuron.init
    assert neuron.ins == []
    assert neuron.outs == []
    assert neuron.cache == []
  end

  test "#add_input" do
    neuron = Neuron.init
    input_neuron = "A PID"
    weight = 4.2
    neuron = neuron |> Neuron.add_input(input_neuron, weight)
    assert neuron.ins == [{"A PID", 4.2}]
  end

  test "#add_output" do
     neuron = Neuron.init
     output_neuron = "A PID"
     neuron = neuron |> Neuron.add_output(output_neuron)
     assert neuron.outs == ["A PID"]
  end

end
