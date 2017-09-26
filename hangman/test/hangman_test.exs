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

  test "makes a move twice" do
    game = Hangman.new_game()
    {game, tally} = Hangman.make_move(game, "a")
    {game, tally} = Hangman.make_move(game, "a")
    assert game.state == :already_used
  end

  test "makes a good guess" do
    game = Hangman.new_game("cats")
    {game, tally} = Hangman.make_move(game, "a")
    assert game.state == :good_guess
  end

  test "makes a bad guess" do
    game = Hangman.new_game("cats")
    {game, tally} = Hangman.make_move(game, "z")
    assert game.state == :bad_guess
  end

  test "wins the game" do
    game = Hangman.new_game("cats")
    {game, tally} = Hangman.make_move(game, "c")
    {game, tally} = Hangman.make_move(game, "a")
    {game, tally} = Hangman.make_move(game, "t")
    {game, tally} = Hangman.make_move(game, "s")
    assert game.state == :won
  end

  test "loses the game" do
    game = Hangman.new_game("cats")
    {game, tally} = Hangman.make_move(game, "c")
    {game, tally} = Hangman.make_move(game, "w")
    {game, tally} = Hangman.make_move(game, "t")
    {game, tally} = Hangman.make_move(game, "b")
    {game, tally} = Hangman.make_move(game, "d")
    {game, tally} = Hangman.make_move(game, "e")
    {game, tally} = Hangman.make_move(game, "f")
    assert game.state == :won
  end

end
