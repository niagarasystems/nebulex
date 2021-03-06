defmodule Nebulex.Adapters.MultilevelExclusiveTest do
  use ExUnit.Case, async: true
  use Nebulex.MultilevelTest, cache: Nebulex.TestCache.MultilevelExclusive

  alias Nebulex.TestCache.MultilevelExclusive, as: Multilevel

  test "get on an exclusive cache" do
    1 = @l1.set 1, 1
    2 = @l2.set 2, 2
    3 = @l3.set 3, 3

    assert Multilevel.get(1) == 1
    assert Multilevel.get(2, return: :key) == 2
    %Object{value: 2, key: 2, version: _} = Multilevel.get(2, return: :object)
    assert Multilevel.get(3) == 3
    refute @l1.get(2)
    refute @l1.get(3)
    refute @l2.get(1)
    refute @l2.get(3)
    refute @l3.get(1)
    refute @l3.get(2)
  end
end
