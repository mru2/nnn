# Neural network coordinator
# Responsabilities are
# - processes management
# - lifecyle handling
# - synchronicity node
defmodule Nnn.Network do

  use GenServer

  alias Nnn.Network.Factory
  alias Nnn.Network.Neuron

  # Struct: neuron pids organized by layer
  defstruct input_layer: [], output_layer: [], last_output: []

  # Client API
  def start_link(layer_sizes, seed \\ :os.timestamp, learning_rate \\ 0.1) do
    GenServer.start_link(__MODULE__, {layer_sizes, seed, learning_rate}, name: :network)
  end

  def evaluate(input_vector) do
    GenServer.call(:network, {:evaluate, input_vector})
  end

  # Training
  def train(input_vector, expected_output) do
    # /!\ Concurrency issue there. Can I do a call in a call ?
    evaluate(input_vector)
    GenServer.cast(:network, {:adjust, expected_output})
  end

  # Server API
  def init({layer_sizes, seed, learning_rate}) do
    {:ok, Factory.create(self, layer_sizes, seed, learning_rate)}
  end

  def handle_call({:evaluate, input_vector}, _from, network) do
    # Send the input vector to the first layer
    Enum.zip(network.input_layer, input_vector)
    |> Enum.each(fn {pid, value} -> Neuron.send_activation(pid, value) end)

    # Wait for the response
    outputs = network.output_layer
    |> Enum.map(fn output -> Neuron.get_activation(output) end)

    {:reply, outputs, %__MODULE__{network | last_output: outputs}}
  end

  def handle_cast({:adjust, expected_output}, network) do
    expected_output
    |> Enum.zip(network.last_output)
    |> Enum.map( fn {expected, actual} -> actual - expected end )
    |> Enum.zip(network.output_layer)
    |> Enum.each( fn {error, neuron} -> Neuron.send_correction(neuron, error) end )

    # Wait for propagation
    _errors = Enum.map(network.input_layer, fn input -> Neuron.get_correction(input) end)

    {:noreply, network}
  end

end
