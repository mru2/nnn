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
    assert res == [0.5197224035870279, 0.7346492282509555]

    (1..10_000) |> Enum.each(fn _ ->
      Network.train([1, 0.6, 0.2, 0], [0, 1])
    end)

    res = Network.evaluate([1, 0.6, 0.2, 0])
    assert res == [0.019164860346195776, 0.9804835887807309]
  end

  test "OR" do
    mappings = [
      { [0, 0], [0] },
      { [1, 0], [1] },
      { [0, 1], [1] },
      { [1, 1], [1] }
    ]

    Network.start_link([2, 3, 1], @seed, 0.5)

    :random.seed(@seed)
    (1..10_000) |> Enum.each(fn _ ->
      {input, output} = Enum.at(mappings, :random.uniform(4) - 1)
      Network.train(input, output)
    end)

    assert [0.05411916194129148] == Network.evaluate([0, 0])
    assert [0.9575867473072632] == Network.evaluate([1, 0])
    assert [0.9957557084001706] == Network.evaluate([0, 1])
    assert [0.9979718524623855] == Network.evaluate([1, 1])

  end

end
