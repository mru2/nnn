defmodule Nnn.Network.Neuron do

  alias Nnn.Neuron

  def start_link(weight) do
    GenServer.start_link(__MODULE__, %Neuron{})
  end

  # ==========
  # Client API
  # ==========
  # Inputs can be a list of pids or of tuples {pid, weight}
  def start_link(inputs \\ [], []) do
    GenServer.start_link(__MODULE__, inputs, [])
  end

  # Add inputs and outputs
  def add_input(neuron, pid, weight) do
    GenServer.cast(neuron, {:add_input, pid, weight})
  end

  def add_output(neuron, pid) do
    GenServer.cast(neuron, {:add_output, pid})
  end

  def signal(neuron, value) do
    send(neuron, {:signal, self, value})
  end

  # =====================
  # Server implementation
  # =====================

  def init(inputs) do
    Neuron.new(inputs)
  end

  def handle_cast({:add_input, pid, weight}, neuron) do
    {:noreply, neuron |> Neuron.with_input({pid, weight})}
  end

  def handle_cast({:add_output, pid}, neuron) do
    {:noreply, neuron |> Neuron.with_output(pid)}
  end

  # Evaluation
  def handle_info({:signal, from, value}, neuron) do
    {neuron, res} = neuron |> Neuron.evaluating(from, value) |> Neuron.check_activation

    # Broadcast if complete
    case res do
      {:activated, out} -> neuron.outs |> Enum.map( &(signal(&1, out)) )
      :unactivated -> true
    end

    {:noreply, neuron}
  end

end
