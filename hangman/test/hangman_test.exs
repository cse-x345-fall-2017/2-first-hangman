defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "New Game State" do
    new_game = Hangman.new_game()
    assert %Hangman.Impl.Tally{ game_state: :initalizing} = new_game
  end

  test "New Game turn value" do
    new_game = Hangman.new_game()
    assert %Hangman.Impl.Tally{ turns_left: 7} = new_game
  end

  test "New Game Letters is not empty" do
    new_game = Hangman.new_game()
    assert %Hangman.Impl.Tally{ letters: []} != new_game
  end


end
