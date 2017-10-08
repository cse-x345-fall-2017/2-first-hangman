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

  test "fill_occurences (helper; arity = 4) returns occurences filled" do
    # word is peeve, guess is 'e'
    word = ["p","e", "e", "v", "e"]
    guess = "e"
    letters = ["_","_", "_", "_", "_"]
    result_1 =  Hangman.Game.fill_occurences(guess, word, letters, [])

    assert result_1 == ["_", "e", "e", "_", "e"]

    result_2 = Hangman.Game.fill_occurences("p", word, result_1, [])

    assert result_2 == ["p", "e", "e", "_", "e"]
  end

  test "fill_occurences (arity = 2) returns new state, occurence of current guess and occurence of last guess" do
    word = ["p","e", "e", "v", "e"]
    guess = "e"
    letters = ["_","_", "_", "_", "_"]

    game = Hangman.new_game()
    game = %State{ game | word: word, letters: letters}

    { state, new, old } = Hangman.Game.fill_occurences(guess,game)
    
    assert %State{} = state
    assert new == ["_", "e", "e", "_", "e"]
    assert old == letters
  end

  test "helper on_good_guess updates state correctly on good guess" do
    word = ["p","e", "e", "v", "e"]
    letters = ["_", "e", "e", "_", "e"]
    
    game = Hangman.new_game()
    game = %State{ game | word: word, letters: letters}

    result = Hangman.Game.on_good_guess(letters, word, game)
    assert %State{ game_state: :good_guess } = result

    letters = ["p", "e", "e", "v", "e"]

    result_2 = Hangman.Game.on_good_guess(letters, word, game)
    assert %State{ game_state: :won } = result_2
  end
end