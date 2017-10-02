defmodule ToolTest do
  use ExUnit.Case
  doctest Hangman.Tool

  test " a list of two underscores returned if get_letters invoked given n = 2 " do
    assert Hangman.Tool.get_letters(2) == ["_","_"]
  end

  test " a combined list with all underscores removed returned if two lists are given " do
    assert  Hangman.Tool.combine(["a", "_", "c"],["_", "b", "_"], 3) == ["a", "b", "c"]
  end
end
