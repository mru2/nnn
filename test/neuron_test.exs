defmodule NeuronTest do
  use ExUnit.Case

  alias Nnn.Neuron
  alias Nnn.Factory

  test "#new" do
    neuron = Neuron.new
    assert neuron.ins == []
    assert neuron.outs == []
  end

  test "#add_input" do
    neuron = Neuron.new
    input_neuron = self
    weight = 4.2
    neuron = neuron |> Neuron.with_input({input_neuron, weight})
    input = hd(neuron.ins)
    assert input.pid == input_neuron
    assert input.weight == 4.2
  end

  test "#add_output" do
     neuron = Neuron.new
     output_neuron = "A PID"
     neuron = neuron |> Neuron.with_output(output_neuron)
     assert neuron.outs == ["A PID"]
  end

  test "#evaluate" do
    neuron = Neuron.new
    |> Neuron.with_input({"IN1", 12})
    |> Neuron.with_input({"IN2", 5})

    assert false == Enum.all?(neuron.ins, &(&1.activated))
    assert { neuron, :unactivated } == Neuron.check_activation(neuron)

    neuron = neuron |> Neuron.evaluating("IN1", 0.3)
    assert { neuron, :unactivated } == Neuron.check_activation(neuron)

    neuron = neuron |> Neuron.evaluating("IN2", -0.5)
    { new_neuron, {:activated, 0.5005202111902349} } = Neuron.check_activation(neuron)
    assert Enum.all?(new_neuron.ins, &(!&1.activated))
  end

end
