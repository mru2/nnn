defmodule Nnn.Network.FactoryTest do
  use ExUnit.Case

  alias Nnn.Network.Factory

  test "#create" do
    {:ok, network} = Factory.create(self, [4, 3, 2], 0.1)
    assert length(network.input_layer) == 4
    assert length(network.output_layer) == 2
  end

end
