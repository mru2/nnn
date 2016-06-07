defmodule NeuronTest do
  use ExUnit.Case

  alias Nnn.Neuron
  alias Nnn.Factory

  test "#new" do
    neuron = Neuron.new
    assert neuron.ins == []
    assert neuron.outs == []
    assert neuron.cache == []
  end

  test "#add_input" do
    neuron = Neuron.new
    input_neuron = "A PID"
    weight = 4.2
    neuron = neuron |> Neuron.with_input(input_neuron, weight)
    assert neuron.ins == [{"A PID", 4.2, nil}]
  end

  test "#add_output" do
     neuron = Neuron.new
     output_neuron = "A PID"
     neuron = neuron |> Neuron.with_output(output_neuron)
     assert neuron.outs == ["A PID"]
  end

  test "#evaluate" do
    neuron = Factory.create_neuron

    # Add mock inputs
    Factory.add_neuron_input(neuron, "IN1", 12)
    Factory.add_neuron_input(neuron, "IN2", 5)

    # Make it send output to us
    Factory.add_neuron_output(neuron, self)

    # Trigger evaluate mode
    Agent.cast neuron, &( &1 |> Neuron.evaluate )

    # Send it signals
    send neuron, {:signal, "IN1", 0.3}
    send neuron, {:signal, "IN2", -0.5}

    # We should reveive the output
    assert_receive {:signal, neuron, 0.5005202111902349}
  end

end
