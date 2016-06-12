defmodule Nnn.Network.NeuronTest do
  use ExUnit.Case

  alias Nnn.Network.Neuron

  test "setup" do
    {:ok, neuron} = Neuron.start_link
    assert Process.alive?(neuron)
  end

  test "activation" do
    {:ok, neuron} = Neuron.start_link([{self, 2}])

    # Add self as an output
    Neuron.add_output(neuron, self)

    # Send a signal
    Neuron.signal(neuron, 0.3)

    # We should receive the activation signal
    assert_receive {:signal, neuron, 0.2913126124515908}
  end
end
