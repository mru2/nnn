# A neuron in the network
# Purely functional logic. Should not be concerned of its existence as a process
defmodule Nnn.Neuron do

  alias Nnn.Neuron

  # Ins : list of tuple with {PID, weight}
  # Outs: list of PID
  # Cache : list of last values received from the input
  defstruct ins: [], outs: [], cache: []

  def init do
    %Neuron{}
  end

  # Add inputs and outputs
  def add_input(neuron, pid, weight) do
    %Neuron{ neuron | ins: neuron.ins ++ [{pid, weight}] }
  end

  def add_output(neuron, pid) do
    %Neuron{ neuron | outs: neuron.outs ++ [pid] }
  end

end
