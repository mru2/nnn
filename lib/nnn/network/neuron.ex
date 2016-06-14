defmodule Nnn.Network.Neuron do

  alias Nnn.Neuron
  alias Nnn.Neuron.Activation
  alias Nnn.Neuron.Correction

  use GenServer

  # ==========
  # Client API
  # ==========
  # Inputs can be a list of pids or of tuples {pid, weight}
  def start_link(inputs \\ [], learning_rate \\ 0.1, bias \\ 0) do
    GenServer.start_link(__MODULE__, {inputs, learning_rate, bias}, [])
  end

  # Add inputs and outputs
  def add_input(neuron, pid) do
    GenServer.cast(neuron, {:add_input, pid})
  end

  def add_input(neuron, pid, weight) do
    GenServer.cast(neuron, {:add_input, pid, weight})
  end

  def add_output(neuron, pid) do
    GenServer.cast(neuron, {:add_output, pid})
  end

  def send_activation(neuron, value) do
    GenServer.cast(neuron, {:activate, self, value})
  end

  def send_correction(neuron, error) do
    GenServer.cast(neuron, {:correct, self, error})
  end

  def get_activation(neuron) do
    receive do
      {:"$gen_cast", {:activate, ^neuron, value}} -> value
    end
  end

  def get_correction(neuron) do
    receive do
      {:"$gen_cast", {:correct, ^neuron, error}} -> error
    end
  end

  # =====================
  # Server implementation
  # =====================

  def init({inputs, learning_rate, bias}) do
    {:ok, Neuron.new(inputs, learning_rate) |> Neuron.with_bias(bias)}
  end

  def handle_cast({:add_input, pid}, neuron) do
    {:noreply, neuron |> Neuron.with_input(pid)}
  end

  def handle_cast({:add_input, pid, weight}, neuron) do
    {:noreply, neuron |> Neuron.with_input({pid, weight})}
  end

  def handle_cast({:add_output, pid}, neuron) do
    {:noreply, neuron |> Neuron.with_output(pid)}
  end

  def handle_cast({:activate, from, value}, neuron) do
    neuron = neuron |> Neuron.with_activation(from, value)

    case Activation.activated?(neuron) do
      false -> {:noreply, neuron}
      true -> handle_activation(neuron)
    end
  end

  def handle_cast({:correct, from, error}, neuron) do
    neuron = neuron |> Neuron.with_correction(from, error)

    case Correction.corrected?(neuron) do
      false -> {:noreply, neuron}
      true -> handle_correction(neuron)
    end
  end

  defp handle_activation(neuron) do
    signal = Activation.output(neuron)
    Enum.each(neuron.outs, fn out -> send_activation(out.pid, signal) end)
    neuron = neuron |> Activation.cleared
    {:noreply, neuron}
  end

  defp handle_correction(neuron) do
    neuron
    |> Correction.backpropagated_errors
    |> Enum.zip(neuron.ins)
    |> Enum.each(fn {error, input} -> send_correction(input.pid, error) end)

    neuron = neuron |> Correction.with_fixed_weights() |> Correction.cleared()
    {:noreply, neuron}
  end

end
