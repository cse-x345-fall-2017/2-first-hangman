defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman
  
  
  test "new game" do
    game = Hangman.new_game()
    assert %{used: [], turns_left: 7, last_guess: ""} = game
    
    tally = Hangman.tally(game)
    assert %{game_state: :initializing, turns_left: 7, last_guess: ""} = tally
  end
    
    
  test "make move(s)" do
    game = Hangman.new_game()
  
    guess1 = "a"
    {game, _tally} = Hangman.make_move(game, guess1)
    assert %{used: [^guess1], last_guess: ^guess1} = game
    
    guess2 = "b"
    {game, _tally} = Hangman.make_move(game, guess2)
    assert guess1 in game.used
    assert guess2 in game.used
    assert %{last_guess: ^guess2} = game  
  end
  
end
