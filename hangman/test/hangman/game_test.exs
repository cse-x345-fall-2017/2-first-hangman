defmodule GameTest do
    use ExUnit.Case
    doctest Hangman.Game
  
    test "test new game returns initializing" do
        game_state = Hangman.new_game()
        assert game_state === { "initializing", 7 }
    end    
end