defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman
  
  
  test "new game" do
    game = Hangman.new_game()
    assert game.used == []
    assert game.turns_left == 7
    assert game.last_guess == ""
    
    guess1 = "a"
    {game, _tally} = Hangman.make_move(game, guess1)
    assert game.used == [guess1]
    assert game.last_guess == guess1
    
    guess2 = "b"
    {game, _tally} = Hangman.make_move(game, guess2)
    assert guess1 in game.used
    assert guess2 in game.used
    assert game.last_guess == guess2
    
  end
end
