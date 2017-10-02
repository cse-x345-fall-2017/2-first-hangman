defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "Words are returned" do
    word1 = Dictionary.random_word()
    assert word1 =~ ~r/^[a-z']+/
  end
  
  test "able to make move true" do
    s1 = "_"
    state1 = %State{}
    state2 = %State{}
    game = Hangman.new_game()
    {state1, state2} = Hangman.make_move(game, "a")
    assert s1 in state2.letters
  end

end
