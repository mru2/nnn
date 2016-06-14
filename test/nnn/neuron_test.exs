defmodule Nnn.NeuronTest do
  use ExUnit.Case

  alias Nnn.Neuron
  alias Nnn.Neuron.Input
  alias Nnn.Neuron.Activation
  alias Nnn.Neuron.Correction

  test "new" do
    neuron = Neuron.new
    assert neuron.ins == []
    assert neuron.outs == []
  end

  test "add_input" do
    neuron = Neuron.new
    input_neuron = self
    weight = 4.2
    neuron = neuron |> Neuron.with_input({input_neuron, weight})
    input = hd(neuron.ins)
    assert input.pid == input_neuron
    assert input.weight == 4.2
  end

  test "add_output" do
     neuron = Neuron.new
     output_neuron = "A PID"
     neuron = neuron |> Neuron.with_output(output_neuron)
     out = hd(neuron.outs)
     assert out.pid == "A PID"
     assert out.error == nil
  end

  test "evaluate" do
    neuron = Neuron.new
    |> Neuron.with_input({"IN1", 8})
    |> Neuron.with_input({"IN2", -6})

    assert false == Activation.activated?(neuron)

    neuron = neuron |> Neuron.with_activation("IN1", 0.9)

    assert false == Activation.activated?(neuron)

    neuron = neuron |> Neuron.with_activation("IN2", 0.5)

    assert true == Activation.activated?(neuron)
    assert 0.9852259683067269 == Activation.output(neuron)

    neuron = neuron |> Activation.cleared

    assert false == Activation.activated?(neuron)
  end

  test "adjusting" do
    neuron = Neuron.new([])
    |> Neuron.with_input({"IN1", 0.15})
    |> Neuron.with_input({"IN2", 0.25})
    |> Neuron.with_output("OUT1")
    |> Neuron.with_output("OUT2")
    |> Neuron.with_activation("IN1", 0.05)
    |> Neuron.with_activation("IN2", 0.10)
    assert false == Correction.corrected?(neuron)

    neuron = neuron |> Neuron.with_correction("OUT1", 0.3)

    assert false == Correction.corrected?(neuron)

    neuron = neuron |> Neuron.with_correction("OUT2", 0.2)

    assert true == Correction.corrected?(neuron)
    assert 0.12496699799738095 == neuron |> Correction.error
    assert [
      0.075,
      0.125
    ] == Correction.backpropagated_errors(neuron)

    neuron = Correction.with_fixed_weights(neuron)
    assert [
      0.14937516501001308,
      0.2487503300200262,
    ] == neuron.ins |> Enum.map(fn input -> input.weight end)

    neuron = neuron |> Correction.cleared

    assert false == Correction.corrected?(neuron)
  end

end
