defmodule Hangman do
  
  defdelegate tally(state), to: Hangman.Game
  defdelegate new_game(), to: Hangman.Game
  defdelegate make_move(current_state, try_letter), to: Hangman.Game

end
