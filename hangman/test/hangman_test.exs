defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "creates new game" do
    %{game_state: game_state} = Hangman.new_game()
    assert game_state == :initializing
  end

  test "check bad guess" do
    letters = String.codepoints("TestWord")
    guess = "z"
    game = %Hangman.Game{letters: letters, last_guess: guess}
    %Hangman.Game{game_state: game_state} = Hangman.Impl.check_guess(game)
    assert game_state == :bad_guess
  end
end
