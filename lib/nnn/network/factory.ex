# Logic for generating a new neural network
defmodule Nnn.Network.Factory do

  alias Nnn.Network
  alias Nnn.Network.Neuron

  # Create a multi-layered network
  # Configured with an array of layer size, and the random seed
  def create(controller, layer_sizes, seed, learning_rate) do
    :random.seed(seed)

    # Create neurons
    layers = layer_sizes |> Enum.map( &( &1 |> create_layer(learning_rate) ) )

    # Link the layers between themselves
    layers
    |> Enum.chunk(2, 1) # Get each consecutive pair
    |> Enum.map( fn [layer_in, layer_out] -> link_layers(layer_in, layer_out) end )

    # Link the input layer
    input_layer = layers |> List.first
    output_layer = layers |> List.last

    input_layer |> Enum.map( &( Neuron.add_input(&1, controller, 2 * :random.uniform - 1) ) )
    output_layer |> Enum.map( &( Neuron.add_output(&1, controller) ) )

    # Return the input and output layers
    %Network{input_layer: input_layer, output_layer: output_layer}
  end

  # Create a new unlinked neuron
  defp create_neuron(learning_rate) do
    bias = 2 * :random.uniform - 1
    {:ok, neuron} = Neuron.start_link([], learning_rate, bias)
    neuron
  end

  # Connect 2 neurons with a given weight
  defp connect(input_neuron, output_neuron) do
    Neuron.add_input(output_neuron, input_neuron, 2 * :random.uniform - 1)
    Neuron.add_output(input_neuron, output_neuron)
  end

  # Create a layer of neurons with a given length
  defp create_layer(size, learning_rate) do
    (1..size) |> Enum.map( fn _i -> create_neuron(learning_rate) end )
  end

  # Link all neurons between 2 layers
  defp link_layers(layer_in, layer_out) do
    for input_neuron <- layer_in, output_neuron <- layer_out do
      connect(input_neuron, output_neuron)
    end
  end

end
