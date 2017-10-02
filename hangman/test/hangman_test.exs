defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  # Tests the new_game() method
  
  test "new game struct successful" do
    test_game = Hangman.new_game()
    assert test_game.turns_left == 7
    assert test_game.game_state == :initializing
    assert length(test_game.letters) > 0
    assert length(test_game.used) == 0
    assert String.length(test_game.word) > 0
    assert String.length(test_game.last_guess) == 0
  end

  # Tests the tally(game) method

  test "tally" do
    default_state = %{ turns_left: 7, 
                       game_state: :initializing,
                       used: [],
                       last_guess: "" }
    test_game = Hangman.new_game()
    assert Hangman.tally(test_game) |> Map.delete(:letters)  == default_state
  end

  # Tests to see if a guess is correct

  test "guess right" do
    test_game = %Hangman.Game{ turns_left: 7,
                               game_state: :initializing, 
                               word: "test",
                               used: [],
                               last_guess: "",
                               letters: ["_", "_", "_", "_"] }
    { _, tally } = Hangman.make_move(test_game, "t")
    assert tally.game_state == :good_guess
  end

  # Tests to see if a guess is incorrect

  test "guess wrong" do
    test_game = %Hangman.Game{ turns_left: 7, 
                               game_state: :initializing,
                               word: "test", 
                               used: ["t"], 
                               last_guess: "t",
                               letters: ["t", "_", "_", "t"] }
    { _, tally } = Hangman.make_move(test_game, "a")
    assert tally.game_state == :bad_guess
  end
  
  # Tests to see if a game can be won

  test "winning game" do 
    test_game = %Hangman.Game{ turns_left: 7, 
                               game_state: :initializing,
                               word: "test", 
                               used: ["t", "e"], 
                               last_guess: "t",
                               letters: ["t", "e", "_", "t"] }
    { _, tally } = Hangman.make_move(test_game, "s")
    assert tally.game_state == :won
  end
  
  # Tests to see if a game can be lost
  
  test "losing game" do 
    test_game = %Hangman.Game{ turns_left: 1, 
                               game_state: :initializing,
                               word: "test", 
                               used: ["t"], 
                               last_guess: "t",
                               letters: ["t", "e", "_", "t"] }
    { _, tally } = Hangman.make_move(test_game, "a")
    assert tally.game_state == :lost
  end

  # Tests to see what happens if you play at turn 0

  test "trying to play at turn 0" do
    test_game = %Hangman.Game{ turns_left: 0, 
                               game_state: :initializing,
                               word: "test", 
                               used: ["t"], 
                               last_guess: "t",
                               letters: ["t", "e", "_", "t"] }
    { _, tally } = Hangman.make_move(test_game, "a")
    assert tally.game_state == :lost
  end
end
