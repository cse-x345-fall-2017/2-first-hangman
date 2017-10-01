defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "greets the world" do
    assert Hangman.hello() == :world
  end

  test "returns new game" do
    state = Hangman.new_game()
    assert state.game_state == :initializing
    assert state.turns_left == 7
    assert state.used == []
    assert state.last_guessed == []

    # Are all characters blanks?
    are_blanks = fn x -> String.equivalent?(x, "_") end
    assert Enum.all?(state.letters, are_blanks) == true
    
    # Is the word non-empty?
    assert [ _head | _tail ] = state.word
  end
end
