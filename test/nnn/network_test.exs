defmodule NetworkTest do
  use ExUnit.Case

  alias Nnn.Network

  @seed {1465, 724879, 361414}

  test "#evaluate" do
    Network.start_link([4, 3, 2], @seed)
    res = Network.evaluate([1, 0.6, 0.2, 0])
    assert res == [0.7507214746121196, 0.636703236960148]
  end

  test "train" do
    Network.start_link([4, 3, 2], @seed)
    res = Network.evaluate([1, 0.6, 0.2, 0])
    assert res == [0.7507214746121196, 0.636703236960148]

    (1..100) |> Enum.each(fn _ ->
      Network.train([1, 0.6, 0.2, 0], [0, 1])
    end)

    res = Network.evaluate([1, 0.6, 0.2, 0])
    assert res == [0.5265943797664001, 0.7251621927847689]
  end

  test "XOR" do
    mappings = [
      { [0, 0], [0] },
      { [1, 0], [1] },
      { [0, 1], [1] },
      { [1, 1], [0] }
    ]

    Network.start_link([2, 4, 1], @seed, 0.5)

    :random.seed(@seed)
    (1..10_000) |> Enum.each(fn _ ->
      {input, output} = Enum.at(mappings, :random.uniform(4) - 1)
      Network.train(input, output)
    end)

    assert [0.5137746324245511] == Network.evaluate([0, 0])
    assert [0.5209357032493271] == Network.evaluate([1, 0])
    assert [0.5326526868539111] == Network.evaluate([0, 1])
    assert [0.5373004010975094] == Network.evaluate([1, 1])

  end

end
