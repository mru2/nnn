# Logic for generating a new neural network
defmodule Nnn.Factory do

  alias Nnn.Network
  alias Nnn.Neuron

  # Create a multi-layered network
  # Configured with an array of layer size
  def create(controller, layer_sizes) do
    # Create neurons
    layers = layer_sizes |> Enum.map(&create_layer/1)

    # Link the layers between themselves
    layers
    |> Enum.chunk(2, 1) # Get each consecutive pair
    |> Enum.map( fn [layer_in, layer_out] -> link_layers(layer_in, layer_out) end )

    # Link the input layer
    input_layer = layers |> List.first
    output_layer = layers |> List.last

    link_input_layer(input_layer, controller)
    link_output_layer(output_layer, controller)

    # Get all the neurons
    neurons = List.flatten(layers)

    # Return the input and output layers
    {:ok, %Network{input_layer: input_layer, output_layer: output_layer, neurons: neurons}}
  end

  # Create a new unlinked neuron
  def create_neuron do
    {:ok, neuron} = Agent.start_link(Neuron, :init, [])
    neuron
  end

  # Connect 2 neurons with a given weight
  def connect(input_neuron, output_neuron, weight) do
    add_neuron_input(output_neuron, input_neuron, weight)
    add_neuron_output(input_neuron, output_neuron)
  end

  # Neuron connection helpers
  defp add_neuron_input(neuron, input, weight) do
    Agent.cast neuron, &( &1 |> Neuron.add_input(input, weight) )
  end

  defp add_neuron_output(neuron, output) do
    Agent.cast neuron, &( &1 |> Neuron.add_output(output) )
  end

  # Create a layer of neurons with a given length
  defp create_layer(size) do
    (1..size) |> Enum.map( fn _i -> create_neuron() end )
  end

  # Link all neurons between 2 layers
  defp link_layers(layer_in, layer_out) do
    for input_neuron <- layer_in, output_neuron <- layer_out do
      connect(input_neuron, output_neuron, 4.2)
    end
  end

  # Link ourselvef to the input layer
  defp link_input_layer(layer, controller) do
    layer |> Enum.map( &( add_neuron_input(&1, controller, 4.2) ) )
  end

  defp link_output_layer(layer, controller) do
    layer |> Enum.map( &( add_neuron_output(&1, controller) ) )
  end

end
