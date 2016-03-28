# Neural network coordinator
# Responsabilities are
# - processes management
# - lifecyle handling
# - synchronicity node
defmodule Nnn.Network do

  alias Nnn.Network
  alias Nnn.Factory

  # Neuron pids organized by layer
  defstruct input_layer: [], output_layer: []

  # Create a multi-layered network
  # Configured with an array of layer size
  def init(layer_sizes) do
    {:ok, {input_layer, output_layer}} = self |> Factory.create(layer_sizes)
    %Network{ input_layer: input_layer, output_layer: output_layer }
  end

end
