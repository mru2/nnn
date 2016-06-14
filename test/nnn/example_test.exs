defmodule Nnn.ExampleTest do
  use ExUnit.Case

  alias Nnn.Neuron
  alias Nnn.Neuron.Activation
  alias Nnn.Neuron.Correction

  # Manual tests for algorithm
  test "output" do
    neuron = Neuron.new([], 0.5)
    |> Neuron.with_input({"H1", 0.4})
    |> Neuron.with_input({"H2", 0.45})
    |> Neuron.with_output("OUT")
    |> Neuron.with_bias(0.6)
    |> Neuron.with_activation("H1", 0.593269992)
    |> Neuron.with_activation("H2", 0.596884378)

    # 0.75136507
    out = Activation.output(neuron)
    assert 0.7513650695224682 == out

    target = 0.01
    neuron = neuron
    |> Neuron.with_correction("OUT", out - target)

    # 0.74136507
    assert 0.7413650695224682 == Correction.external_error(neuron)

    # 0.186815602
    assert 0.18681560182396473 == Correction.internal_error(neuron)

    neuron = neuron
    |> Correction.with_fixed_weights

    new_weights = Enum.map(neuron.ins, fn input -> input.weight end)

    assert [
      0.3589164797236614, # 0.35891648
      0.4086661860925662 # 0.408666186
    ] == new_weights
  end
end
