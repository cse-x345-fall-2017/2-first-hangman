defmodule GameTest do
    use ExUnit.Case
    doctest Hangman.Game
  
    test "creating a new game" do
        game = Hangman.Game.new_game()
        assert %GameState{ game_state: :initializing,
                           turns_left: 7,
                           used: [],
                           last_guess: "" } = game
    end
    
    test "initial call to tally" do
        game = Hangman.Game.new_game("testword")
        assert %{ game_state: :initializing, 
                  turns_left: 7, 
                  letters:    ["_", "_", "_","_", "_", "_", "_", "_"],
                  used:       [] } = Hangman.Game.tally(game)
    end

    test "make move :bad_guess" do
          game = Hangman.Game.new_game("testword") 
          assert { %GameState{ game_state: :bad_guess, 
                        turns_left: 6,
                        letters: ["_", "_", "_","_", "_", "_", "_", "_"],
                        used: ["z"],
                        last_guess: "z" }, _tally } = Hangman.Game.make_move( game, "z" )    
    end

    test "make move :good_guess" do
         game = Hangman.Game.new_game("testword") 
         { %GameState{ game_state: :good_guess, 
                       turns_left: 7,
                       letters: ["t", "_", "_", "t", "_", "_", "_", "_"],
                       used: ["t"],
                       last_guess: "t" }, _tally } = Hangman.Game.make_move( game, "t" )
        
    end

    test "make move :already_used" do
         game = Hangman.Game.new_game("testword") 
         {game,tally} = Hangman.Game.make_move( game, "t" )
         assert { %GameState{ game_state: :already_used }, _tally } = Hangman.Game.make_move( game, "t" )
                         
    end

    test "make move :won" do
         game = Hangman.Game.new_game("testword") 
         {game,_} = Hangman.Game.make_move( game, "t" )
         {game,_} = Hangman.Game.make_move( game, "e" )
         {game,_} = Hangman.Game.make_move( game, "s" )
         {game,_} = Hangman.Game.make_move( game, "w" )
         {game,_} = Hangman.Game.make_move( game, "o" )
         {game,_} = Hangman.Game.make_move( game, "r" )
         assert { %GameState{ game_state: :won, letters: ["t", "e", "s","t", "w", "o", "r", "d"] }, _tally } = Hangman.Game.make_move( game, "d" )
        
    end

    test "make move :lost" do
         game = Hangman.Game.new_game("testword") 
         {game,_} = Hangman.Game.make_move( game, "z" )
         {game,_} = Hangman.Game.make_move( game, "a" )
         {game,_} = Hangman.Game.make_move( game, "b" )
         {game,_} = Hangman.Game.make_move( game, "c" )
         {game,_} = Hangman.Game.make_move( game, "q" )
         {game,_} = Hangman.Game.make_move( game, "y" )
         assert { %GameState{ game_state: :lost, letters: ["t", "e", "s","t", "w", "o", "r", "d"] }, _tally } = Hangman.Game.make_move( game, "p" )        
    end
 
    test "valid character" do
         game = Hangman.Game.new_game("testword") 
         {game,_} = Hangman.Game.make_move( game, "@")
    end
end