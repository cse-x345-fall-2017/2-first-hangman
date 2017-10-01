defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman
  doctest Hangman.Game
  test "init word is cat" do 
  game =Hangman.Game.init_game("cat")
  tally = Hangman.tally(game)
  assert tally.game_state == :initializing
  {game,tally} = Hangman.make_move(game,"a")
  assert tally.letters == ["_","a","_"]
  assert tally.game_state == :good_guess
  {game,tally} = Hangman.make_move(game,"b")
  assert tally.letters == ["_","a","_"]
  assert tally.game_state == :bad_guess
  {game,tally} = Hangman.make_move(game,"c")
  assert tally.letters == ["c","a","_"]
  assert tally.game_state == :good_guess
  {_game,tally} = Hangman.make_move(game,"t")
  assert tally.letters == ["c","a","t"]
  assert tally.game_state == :won
  end

 test "init word is complex" do 
  game =Hangman.Game.init_game("complex")
  tally = Hangman.tally(game)
  assert tally.game_state == :initializing
  {game,tally} = Hangman.make_move(game,"a")
  assert tally.letters == ["_","_","_","_","_","_","_"]
  assert tally.game_state == :bad_guess
  {game,tally} = Hangman.make_move(game,"c")
   assert tally.letters == ["c","_","_","_","_","_","_"]
  assert tally.game_state == :good_guess
  {game,tally} = Hangman.make_move(game,"x")
   assert tally.letters == ["c","_","_","_","_","_","x"]
  assert tally.game_state == :good_guess
  {game,tally} = Hangman.make_move(game,"b")
   assert tally.letters == ["c","_","_","_","_","_","x"]
   assert tally.game_state == :bad_guess
   {game,tally} = Hangman.make_move(game,"n")
   assert tally.letters == ["c","_","_","_","_","_","x"]
   assert tally.game_state == :bad_guess
   {game,tally} = Hangman.make_move(game,"f")
   assert tally.letters == ["c","_","_","_","_","_","x"]
   assert tally.game_state == :bad_guess
   {game,tally} = Hangman.make_move(game,"k")
   assert tally.letters == ["c","_","_","_","_","_","x"]
   assert tally.game_state == :bad_guess
   {game,tally} = Hangman.make_move(game,"y")
   assert tally.letters == ["c","_","_","_","_","_","x"]
   assert tally.game_state == :bad_guess
   {_game,tally} = Hangman.make_move(game,"u")
   assert tally.letters == ["c","o","m","p","l","e","x"]
   assert tally.game_state == :lost
  end 

 test "test from github" do
   game=Hangman.Game.init_game("cat")
   assert  Hangman.tally(game) == %{ game_state: :initializing, turns_left: 7, letters: ["_", "_", "_"], used: [], last_guess: ""}
   { game, tally } = Hangman.make_move(game, "a")
   assert tally == %{ game_state: :good_guess, turns_left: 7, letters: ["_", "a", "_"], used: ["a"], last_guess: "a" }
   { game, tally } = Hangman.make_move(game, "b")
   assert tally == %{ game_state: :bad_guess, turns_left: 6, letters: ["_", "a", "_"], used: ["a", "b"], last_guess: "b"  }
   { game, tally } = Hangman.make_move(game, "c")
   assert tally == %{ game_state: :good_guess, turns_left: 6, letters: ["c", "a", "_"], used: ["a", "b", "c"], last_guess: "c"  }
   {_game, tally } = Hangman.make_move(game, "t")
   assert  tally == %{ game_state: :won, turns_left: 6, letters: ["c", "a", "t"], used: ["a", "b", "c", "t"], last_guess: "t"  }
 end
 
end
