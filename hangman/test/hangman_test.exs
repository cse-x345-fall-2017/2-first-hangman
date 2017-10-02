defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test " a struct returned if new_game() is invoked " do
    game = Hangman.new_game()
    assert is_map(game)      == true
    assert game.game_state   == :initializing
    assert game.turns_left   == 7
    assert game.word         != []
    assert game.letters      != []
    assert length(game.word) == length(game.letters)
    assert game.used         == []
    assert game.last_guess   == ""
  end

  test " a map returned if tally() invoked given a struct " do
    game = %Hangman.Struct{}
    assert Hangman.tally(game).game_state == :initializing
    assert Hangman.tally(game).turns_left == 7
    assert Hangman.tally(game)[:word]     == nil
    assert Hangman.tally(game).letters    == []
    assert Hangman.tally(game).used       == []
    assert Hangman.tally(game).last_guess == ""
  end

  test " make_move() to :good_guess and :won " do
    game = %Hangman.Struct{ turns_left: 2, word: ["a", "b"], letters: ["_", "_"]}
    { new_game, tally } = Hangman.make_move(game,"a")
    assert is_map(new_game)    == true
    assert is_map(tally)       == true
    assert new_game.game_state == :good_guess
    assert new_game.word       == ["_", "b"]
    assert new_game.letters    == ["a", "_"]
    assert new_game.used       == ["a"]
    assert new_game.last_guess == "a"
    { new_game, _tally } = Hangman.make_move(new_game,"b")
    assert new_game.game_state == :won
    assert new_game.word       == ["_", "_"]
    assert new_game.letters    == ["a", "b"]
    assert new_game.used       == ["a", "b"]
    assert new_game.last_guess == "b"
  end

  test "make_move() to :bad_guess and :lost" do
    game = %Hangman.Struct{ turns_left: 2, word: ["a", "b"], letters: ["_", "_"]}
    { new_game, _tally } = Hangman.make_move(game,"c")
    assert new_game.game_state == :bad_guess
    assert new_game.word       == ["a", "b"]
    assert new_game.letters    == ["_", "_"]
    assert new_game.turns_left == 1
    { new_game, _tally } = Hangman.make_move(new_game,"d")
    assert new_game.game_state == :lost
    assert new_game.word       == ["a", "b"]
    assert new_game.letters    == ["a", "b"]
    assert new_game.turns_left == 0
  end
  
end
