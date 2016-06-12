defmodule NetworkTest do
  use ExUnit.Case

  alias Nnn.Network

  @seed {1465, 724879, 361414}

  test "#evaluate" do
    Network.start_link([4, 3, 2], @seed)
    res = Network.evaluate([1, 0.6, -0.2, -1])
    assert res == [-0.020718603640745514, 0.017354608558158846]
  end

  test "#train" do
  end

end
