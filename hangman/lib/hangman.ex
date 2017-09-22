defmodule Hangman do

  # Hangman.new_game()                # returns a struct representing a new game
  
  # Hangman.tally(game)               # returns the tally for the given game
    
  # Hangman.make_move(game, guess)    # returns a tuple containing the updated game
  #                                   # state and a tally

  defdelegate new_game(), to: Hangman.Game
  defdelegate tally(game), to: Hangman.Game
  defdelegate make_move(game, guess), to: Hangman.Game
  
end
