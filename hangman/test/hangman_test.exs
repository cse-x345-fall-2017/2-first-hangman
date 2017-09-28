defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman
  
  
  test "game states, turns left => win" do
  
    game = Hangman.new_game_test("this")
    
    tally = Hangman.tally(game)
    %{game_state: :initializing, turns_left: 7} = tally
    
    {game, tally} = Hangman.make_move(game, "t") # correct
    %{game_state: :good_guess,   turns_left: 7} = tally
    
    {game, tally} = Hangman.make_move(game, "a") # wrong #1
    %{game_state: :bad_guess,    turns_left: 6} = tally
    
    {game, tally} = Hangman.make_move(game, "a") # already used
    %{game_state: :already_used, turns_left: 6} = tally
    
    {game, tally} = Hangman.make_move(game, "p") # wrong #2
    %{game_state: :bad_guess,    turns_left: 5} = tally
    
    {game, tally} = Hangman.make_move(game, "h") # correct
    %{game_state: :good_guess,   turns_left: 5} = tally
    
    {game, tally} = Hangman.make_move(game, "i") # correct
    %{game_state: :good_guess,   turns_left: 5} = tally
    
    {game, tally} = Hangman.make_move(game, "o") # wrong #3
    %{game_state: :bad_guess,    turns_left: 4} = tally
    
    {_game,tally} = Hangman.make_move(game, "s") # correct
    %{game_state: :won,          turns_left: 4} = tally
    
  end
  
  
  test "game state, letters, turns left => lost" do
  
    game = Hangman.new_game_test("this")
    
    tally = Hangman.tally(game)
    %{turns_left: 7, letters: ["_","_","_","_"]} = tally
    
    {game, _tally} = Hangman.make_move(game, "a") # wrong
    {game, _tally} = Hangman.make_move(game, "b") # wrong
    {game, _tally} = Hangman.make_move(game, "c") # wrong
    {game, _tally} = Hangman.make_move(game, "d") # wrong
    {game, _tally} = Hangman.make_move(game, "e") # wrong
    {game, _tally} = Hangman.make_move(game, "f") # wrong
    {_game, tally} = Hangman.make_move(game, "g") # wrong
    
    # when the user loses, all letters shall be filled in
    %{game_state: :lost, letters: ["t","h","i","s"], turns_left: 0} = tally
    
  end
  
  
  test "letters guessed" do
  
    game = Hangman.new_game_test("this")
    
    {game, tally} = Hangman.make_move(game, "t") # correct
    %{letters: ["t","_","_","_"]} = tally
    
    {game, tally} = Hangman.make_move(game, "a") # wrong
    %{letters: ["t","_","_","_"]} = tally
    
    {game, tally} = Hangman.make_move(game, "s") # correct
    %{letters: ["t","_","_","s"]} = tally
    
    {game, tally} = Hangman.make_move(game, "b") # wrong
    %{letters: ["t","_","_","s"]} = tally
    
    {game, tally} = Hangman.make_move(game, "i") # correct
    %{letters: ["t","_","i","s"]} = tally
    
    {_game,tally} = Hangman.make_move(game, "h") # correct
    %{letters: ["t","h","i","s"]} = tally
    
  end
  
  
  test "letters used" do
  
    game = Hangman.new_game_test("this")
    
    {game, tally} = Hangman.make_move(game, "t")
    %{used: ["t"]} = tally
    
    {game, tally} = Hangman.make_move(game, "a")
    %{used: ["a","t"]} = tally
    
    {game, tally} = Hangman.make_move(game, "a") # already used
    %{used: ["a","t"]} = tally
    
    {game, tally} = Hangman.make_move(game, "s")
    %{used: ["a","s","t"]} = tally
    
    {game, tally} = Hangman.make_move(game, "n")
    %{used: ["a","n","s","t"]} = tally
    
    {_game,tally} = Hangman.make_move(game, "e")
    %{used: ["a","e","n","s","t"]} = tally
    
  end
  
  
end