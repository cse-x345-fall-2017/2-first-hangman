defmodule Hangman do
  
  defdelegate new_game(),            to: Hangman.Init  #returns a struct representing a new game
  defdelegate tally(game),           to: Hangman.Tally #returns the tally for the given game
  defdelegate make_move(game,guess), to: Hangman.Move  #returns a tuple containing the updated game
                                             #state and a tally
end
