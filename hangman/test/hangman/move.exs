defmodule MoveTest do
  use ExUnit.Case
  doctest Hangman.Move

  test " a struct returned if is_in() invoked " do
    game = %Hangman.Struct{ word: ["a"], letters: ["_"] }
    exp  = %Hangman.Struct{ game_state: :good_guess, word: ["_"], letters: ["a"], used: ["a"], last_guess: ["a"] }
    assert is_in(true, game, "a") == exp
  end

  test " a struct with letters that indicate the whole word returned if is_lost() invoked given para true" do
    game = %Hangman.Struct{ word: ["a", "b", "_"], letters: ["_", "_", "c"] }
    exp  = %Hangman.Struct{ game_state: :lost, word: ["a", "b", "_"], letters: ["a", "b", "c"] }
    assert is_lost(true, game) == exp
  end
end
