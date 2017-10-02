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
    {_ , _} = Hangman.make_move(game, "a")
  end

  test "makes a move twice" do
    game = Hangman.new_game()
    {game, _} = Hangman.make_move(game, "a")
    {game, _} = Hangman.make_move(game, "a")
    assert game.game_state == :already_used
  end

  test "makes a good guess" do
    game = Hangman.new_game("cats")
    {%{game_state: game_state}, _} = Hangman.make_move(game, "a")
    assert game_state == :good_guess
  end

  test "makes a bad guess" do
    game = Hangman.new_game("cats")
    {game, _} = Hangman.make_move(game, "z")
    assert game.game_state == :bad_guess
  end

  test "wins the game" do
    game = Hangman.new_game("cats")
    {game, _} = Hangman.make_move(game, "c")
    {game, _} = Hangman.make_move(game, "a")
    {game, _} = Hangman.make_move(game, "t")
    {game, _} = Hangman.make_move(game, "s")
    assert game.game_state == :won
  end

  test "loses the game" do
    game = Hangman.new_game("cats")
    {game, _} = Hangman.make_move(game, "b")
    {game, _} = Hangman.make_move(game, "d")
    {game, _} = Hangman.make_move(game, "e")
    {game, _} = Hangman.make_move(game, "f")
    {game, _} = Hangman.make_move(game, "g")
    {game, _} = Hangman.make_move(game, "h")
    {%{game_state: game_state}, _} = Hangman.make_move(game, "i")
    assert game_state == :lost
  end

  test "letters updates" do
    game = Hangman.new_game("cats")
    {%{letters: letters}, _} = Hangman.make_move(game, "c")
    assert "c" in letters
  end

end
