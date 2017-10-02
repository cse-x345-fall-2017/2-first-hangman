defmodule GameTest do
  use ExUnit.Case

  test "guess is checked correctly" do
    # Using test word "elba"
    game = Hangman.new_game()
    game = %State{game |
    word: ["e", "l", "b", "a"],
    letters: ["_", "_", "_", "_"]
    }

    assert ["e", "_", "_", "_"] == Hangman.Game.check(game.word,
                                                     "e",
                                                     game.letters)       
  end
end