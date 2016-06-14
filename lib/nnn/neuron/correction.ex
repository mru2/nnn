# Beware! Send backpropagation before fixing weights
# 1. sum errors : error_total
# 2. get_internal_error: error = error_total * out * (1 - out)
# 3. fix weights : w_i = w_i - learning_rate * error * input_i
# 4. backpropagate error : error * w_i ( /!\ the weigth before correction ! )

defmodule Nnn.Neuron.Correction do

  alias Nnn.Neuron
  alias Nnn.Neuron.Input
  alias Nnn.Neuron.Output
  alias Nnn.Neuron.Activation

  def corrected?(neuron), do: Enum.all?(neuron.outs, &(&1.error))

  def cleared(neuron) do
    cleared_outs = neuron.outs |> Enum.map( &Output.clear/1 )
    %Neuron{ neuron | outs: cleared_outs }
  end

  def error(neuron), do: external_error(neuron) * internal_error(neuron)

  def external_error(neuron), do: Enum.map(neuron.outs, &(&1.error)) |> Enum.sum
  def internal_error(neuron) do
    actual_output = Activation.output(neuron)
    actual_output * (1 - actual_output)
  end

  def with_fixed_weights(neuron) do
    correction = neuron.learning_rate * error(neuron)
    fixed_ins = Enum.map(neuron.ins, fn input ->
      new_weight = input.weight - correction * input.value
      %Input{ input | weight: new_weight }
    end)

    %Neuron{ neuron | ins: fixed_ins }
  end

  def backpropagated_errors(neuron) do
    error = external_error(neuron)
    Enum.map(neuron.ins, fn input -> input.weight * error end)
  end

end
