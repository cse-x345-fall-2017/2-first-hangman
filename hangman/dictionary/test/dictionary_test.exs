defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "Words are returned" do
    word1 = Dictionary.random_word()
    assert word1 =~ ~r/^[a-z']+/
  end
end
