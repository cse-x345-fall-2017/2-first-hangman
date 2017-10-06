defmodule GameTest do
  use ExUnit.Case

  # test "guess is evaluated correctly" do
  #   # Using test word "elba"
  #   game = Hangman.new_game()
  #   game = %State{game |
  #   word: ["e", "l", "b", "a"],
  #   letters: ["_", "_", "_", "_"]
  #   }

  #   assert ["e", "_", "_", "_"] == Hangman.Game.check(game.word,
  #                                                    "e",
  #                                                    game.letters)       
  # end

  test " guess is evaluated correctly" do
    # word is peeve, guess is 'e'
    word = ["p","e", "e", "v", "e"]
    guess = "e"
    letters = ["_","_", "_", "_", "_"]
    result_1 =  Hangman.Game.evaluate(guess, word, letters)

    assert result_1 == ["_", "e", "e", "_", "e"]

    result_2 = Hangman.Game.evaluate("p", word, result_1)

    assert result_2 == ["p", "e", "e", "_", "e"]
  end
end