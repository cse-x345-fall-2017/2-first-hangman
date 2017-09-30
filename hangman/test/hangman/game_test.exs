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
        game = Hangman.Game.new_game()
        game = %GameState{ letters: ["_", "_", "_"] }
        assert %{ game_state: :initializing, 
                  turns_left: 7, 
                  letters:    ["_", "_", "_"],
                  used:       [] } = Hangman.Game.tally(game)
    end

    # test "make move :bad_guess" do
    #     game = Hangman.Game.new_game("cat") 
    #     { %GameState{ game_state: :bad_guess, 
    #                   turns_left: 6,
    #                   letter: ["_", "_", "_"],
    #                   used: ["s"],
    #                   last_guess: "s" }, _tally } = Hangman.Game.make_move( game, "s" )    
    # end

    test "make move :good_guess" do
        game = Hangman.Game.new_game("cat") 
        { %GameState{ game_state: :good_guess, 
                      turns_left: 7,
                      letters: ["_", "a", "_"],
                      used: ["a"],
                      last_guess: "a" }, _tally } = Hangman.Game.make_move( game, "a" )
        
    end

    test "make move :already_used" do
        
    end

    test "make move :won" do
        
    end

    test "make move :lost" do
        
    end
 
end