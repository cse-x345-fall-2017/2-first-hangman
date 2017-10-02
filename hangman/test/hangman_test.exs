defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "New Game State" do
    new_game = Hangman.new_game()
    assert new_game.game_state == :initalizing
  end

  test "New Game turn value" do
    new_game = Hangman.new_game()
    assert new_game.turns_left == 7
  end

  test "New Game Letters is not empty" do
    new_game = Hangman.new_game()
    assert length(new_game.letters) > 0
  end

  test "Used Letters is empty" do
    new_game = Hangman.new_game()
    assert length(new_game.used) == 0
  end

  test "New Game word is not empty" do
    new_game = Hangman.new_game()
    assert String.length(new_game.word) > 0
  end

  describe "a good guess" do
    test "should update game correctly" do
      game = %Hangman.Impl.Tally{
        game_state: :initalizing,
        letters: ["_", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 7,
        used: [],
        word: "sympathy"
      }
      { game, _ } = Hangman.make_move(game, "s")
      check_game = %Hangman.Impl.Tally{
        game_state: :good_guess,
        letters: ["s", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 7,
        used: ["s"],
        word: "sympathy"
      }
      assert game == check_game
    end

    test "should update tally correctly" do
      game = %Hangman.Impl.Tally{
        game_state: :initalizing,
        letters: ["_", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 7,
        used: [],
        word: "sympathy"
      }
      { game, tally } = Hangman.make_move(game, "s")
      assert Hangman.tally(game) == tally
    end

    test "should return a win when appropriate" do
      game = %Hangman.Impl.Tally{
        game_state: :initalizing,
        letters: ["c", "a", "_"],
        turns_left: 7,
        used: ["c", "a"],
        word: "cat"
      }
      { game, _ } = Hangman.make_move(game, "t")
      assert game.game_state == :won
    end

  end

  describe "a bad guess" do
    test "should update game correctly" do
      game = %Hangman.Impl.Tally{
        game_state: :initalizing,
        letters: ["_", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 7,
        used: [],
        word: "sympathy"
      }
      { game, _ } = Hangman.make_move(game, "x")
      check_game = %Hangman.Impl.Tally{
        game_state: :bad_guess,
        letters: ["_", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 6,
        used: ["x"],
        word: "sympathy"
      }
      assert game == check_game
    end

    test "should update tally correctly" do
      game = %Hangman.Impl.Tally{
        game_state: :initalizing,
        letters: ["_", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 6,
        used: ["x"],
        word: "sympathy"
      }
      { game, tally } = Hangman.make_move(game, "x")
      assert Hangman.tally(game) == tally
    end

    test "should return loss correctly" do
      game = %Hangman.Impl.Tally{
        game_state: :bad_guess,
        letters: ["_", "_", "_"],
        turns_left: 0,
        used: ["x", "e", "s"],
        word: "cat"
      }
      { game, _ } = Hangman.make_move(game, "z")
      assert game.game_state == :lost
    end
  end

  describe "a guess that has already been used" do
    test "should update game correctly" do
      game = %Hangman.Impl.Tally{
        game_state: :good_guess,
        letters: ["s", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 6,
        used: ["s"],
        word: "sympathy"
      }
      { game, _ } = Hangman.make_move(game, "s")
      check_game = %Hangman.Impl.Tally{
        game_state: :already_used,
        letters: ["s", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 6,
        used: ["s"],
        word: "sympathy"
      }
      assert game == check_game
    end

    test "should update tally correctly" do
      game = %Hangman.Impl.Tally{
        game_state: :good_guess,
        letters: ["s", "_", "_", "_", "_", "_", "_", "_"],
        turns_left: 6,
        used: ["s"],
        word: "sympathy"
      }
      { game, tally } = Hangman.make_move(game, "s")
      assert Hangman.tally(game) == tally
    end
  end


end
