# Neural network coordinator
# Responsabilities are
# - processes management
# - lifecyle handling
# - synchronicity node
defmodule Nnn.Network do

  # Neuron pids organized by layer
  defstruct input_layer: [], output_layer: [], neurons: []

end
