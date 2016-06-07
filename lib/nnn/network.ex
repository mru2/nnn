# Neural network coordinator
# Responsabilities are
# - processes management
# - lifecyle handling
# - synchronicity node
defmodule Nnn.Network do

  alias Nnn.Neuron

  # Neuron pids organized by layer
  defstruct input_layer: [], output_layer: [], neurons: []

  def evaluate(network, input_vector) do
    # Trigger the neurons to evaluate
    Enum.each(network.neurons, fn neuron ->
      Agent.cast neuron, &( &1 |> Neuron.evaluate )
    end)

    # Send the input vector to the first layer
    Enum.zip(network.input_layer, input_vector)
    |> Enum.map( fn {pid, value} ->
      send(pid, {:signal, self, value})
    end)

    # Wait for the response
    Enum.map(network.output_layer, fn pid ->
      receive do
       {:signal, ^pid, value} -> value
      end
    end)
  end

end
