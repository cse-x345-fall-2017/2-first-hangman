defmodule HumanPlayerTest do
  use ExUnit.Case
  doctest HumanPlayer

  test "greets the world" do
    assert HumanPlayer.hello() == :world
  end
end
