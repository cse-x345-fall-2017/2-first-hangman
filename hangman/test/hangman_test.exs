defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "test new_game" do
    game = Hangman.new_game()
    assert String.length(game.word) > 0
    assert game.word_to_list != []
    assert game.game_state == :initializing 
    assert game.letters != []
    assert game.used == []
    assert game.last_guess == ""
    assert game.turns_left == 7
  end

  test "test vally shows only what should be showed" do
    game = Hangman.Impl.initState("toby")
    assert Hangman.tally(game) == %{game_state: :initializing,
                                    turns_left: 7,
                                    letters: ["_", "_", "_", "_"],
                                    used: [],
                                    last_guess: ""
                                   }
  end


  test "make_move, :already_used" do
    game = Hangman.new_game()
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "a")
    {game, _tally} = Hangman.make_move(game, "a")
    assert game.game_state == :already_used
  end



  test "make_move, can :already_used detect?" do
    game = Hangman.new_game()
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "a")
    {game, _tally} = Hangman.make_move(game, "a")
    assert game.game_state == :already_used
  end


  test "make_move, can :lost detect?" do
    game = Hangman.Impl.initState("toby")
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "a")
    {game, _tally} = Hangman.make_move(game, "c")
    {game, _tally} = Hangman.make_move(game, "d")
    {game, _tally} = Hangman.make_move(game, "e")
    {game, _tally} = Hangman.make_move(game, "f")
    {game, _tally} = Hangman.make_move(game, "g")
    {game, _tally} = Hangman.make_move(game, "h")
    assert game.game_state == :lost
  end



  test "make_move, can :won detect?" do
    game = Hangman.Impl.initState("toby")
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "t")
    {game, _tally} = Hangman.make_move(game, "o")
    {game, _tally} = Hangman.make_move(game, "b")
    {game, _tally} = Hangman.make_move(game, "y")
    assert game.game_state == :won
  end


end
