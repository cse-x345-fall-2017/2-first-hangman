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



  test "make_move, can :already_used detect?" do
    game = Hangman.new_game()
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "a")
    {game, _tally} = Hangman.make_move(game, "a")
    assert game.game_state == :already_used
  end




  test "make_move, will last_guess update?" do
    game = Hangman.new_game()
    Hangman.tally(game)
    {_game, tally} = Hangman.make_move(game, "a")
    assert tally.last_guess == "a"
    {_game, tally} = Hangman.make_move(game, "b")
    assert tally.last_guess == "b"
  end








  test "make_move, can used update when different guess?" do
    game = Hangman.new_game()
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "a")
    {game, _tally} = Hangman.make_move(game, "b")
    assert game.used == ["a", "b"]
  end


  test "make_move, will good or bad guess detect?" do
    game = Hangman.Impl.initState("toby")
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "a")
    assert game.game_state == :bad_guess
    {game, _tally} = Hangman.make_move(game, "t")
    assert game.game_state == :good_guess
    
  end



  test "make_move, will turns_left decreases when bad guess?" do
    game = Hangman.Impl.initState("toby")
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "a")
    assert game.turns_left == 6
  end


  test "make_move, will turns_left holds when good guess?" do
    game = Hangman.Impl.initState("toby")
    Hangman.tally(game)
    {game, _tally} = Hangman.make_move(game, "t")
    assert game.turns_left == 7
    {game, _tally} = Hangman.make_move(game, "o")
    assert game.turns_left == 7
    {game, _tally} = Hangman.make_move(game, "b")
    assert game.turns_left == 7
    {game, _tally} = Hangman.make_move(game, "y")
    assert game.turns_left == 7
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
