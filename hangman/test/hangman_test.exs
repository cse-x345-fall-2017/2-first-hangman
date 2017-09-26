defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "creates a game" do
    Hangman.new_game()
  end

  test "gets a tally" do
    game = Hangman.new_game()
    Hangman.tally(game)
  end

  test "makes a move" do
    game = Hangman.new_game()
    {game, tally} = Hangman.make_move(game, "a")
  end
end
