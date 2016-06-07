defmodule NetworkTest do
  use ExUnit.Case

  alias Nnn.Factory
  alias Nnn.Network

  test "#evaluate" do
    {:ok, network} = Factory.create(self, [4, 3, 2])
    res = network |> Network.evaluate([1, 0.6, -0.2, -1])
    assert res == [0.9998247234756188, 0.9998247234756188]

    res = network |> Network.evaluate([1, 0.4, -0.1, -1])
    assert res == [0.9998247234756188, 0.9998247234756188]
  end

  test "With custom weights" do

  end

end
