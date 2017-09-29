defmodule HangmanTest do
  use ExUnit.Case

  describe "Test state updates" do
    test ":lost on 0 turns_left" do
      game = %Hangman.Game{ turns_left: 0, game_state: :lost,
        word: "dog", used: ["a"], last_guess: "a",
        letters: ["_", "_", "_"] }

      { _, tally } = Hangman.make_move(game, "b")
      assert tally.game_state == :lost
    end

    test ":already_used on guessing letter in used" do
      game = %Hangman.Game{ turns_left: 6, game_state: :good_guess,
        word: "dog", used: ["a"], last_guess: "a",
        letters: ["_", "_", "_"] }

      { _, tally } = Hangman.make_move(game, "a")
      assert tally.game_state == :already_used
    end

    test ":lost on bad guess and 1 turn left" do
      game = %Hangman.Game{ turns_left: 1, game_state: :bad_guess,
        word: "dog", used: ["a"], last_guess: "a",
        letters: ["_", "_", "_"] }

      { _, tally } = Hangman.make_move(game, "b")
      assert tally.game_state == :lost
    end

    test ":bad_guess on letter not in word" do
      game = %Hangman.Game{ turns_left: 4, game_state: :good_guess,
        word: "dog", used: ["d"], last_guess: "d",
        letters: ["d", "_", "_"] }

      { _, tally } = Hangman.make_move(game, "b")
      assert tally.game_state == :bad_guess
    end

    test ":good_guess on letter in word" do
      game = %Hangman.Game{ turns_left: 4, game_state: :bad_guess,
        word: "dog", used: ["b"], last_guess: "b",
        letters: ["_", "_", "_"] }

      { _, tally } = Hangman.make_move(game, "d")
      assert tally.game_state == :good_guess
    end

    test ":won on guessed last letter in word" do
      game = %Hangman.Game{ turns_left: 4, game_state: :good_guess,
        word: "dog", used: ["d", "o"], last_guess: "o",
        letters: ["d", "o", "_"] }

      { _, tally } = Hangman.make_move(game, "g")
      assert tally.game_state == :won
    end
  end

end
