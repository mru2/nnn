# Neural network coordinator
# Responsabilities are
# - processes management
# - lifecyle handling
# - synchronicity node
defmodule Nnn.Network do

  use GenServer

  alias Nnn.Network.Factory

  # Struct: neuron pids organized by layer
  defstruct input_layer: [], output_layer: []

  # Client API
  def start_link(layer_sizes, seed \\ :os.timestamp) do
    GenServer.start_link(__MODULE__, {layer_sizes, seed}, name: :network)
  end

  def evaluate(input_vector) do
    GenServer.call(:network, {:evaluate, input_vector})
  end

  # Server API
  def init({layer_sizes, seed}) do
    {:ok, Factory.create(self, layer_sizes, seed)}
  end

  def handle_call({:evaluate, input_vector}, _from, network) do
    # Send the input vector to the first layer
    Enum.zip(network.input_layer, input_vector)
    |> Enum.map( fn {pid, value} ->
      send(pid, {:signal, self, value})
    end)

    # Wait for the response
    out = Enum.map(network.output_layer, fn pid ->
      receive do
       {:signal, ^pid, value} -> value
      end
    end)

    {:reply, out, network}
  end

end
