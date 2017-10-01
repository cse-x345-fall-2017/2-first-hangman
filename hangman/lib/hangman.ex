defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """
  
  defdelegate new_game(),             to: Hangman.Game
  defdelegate tally(game),            to: Hangman.Game
  defdelegate make_move(game, guess), to: Hangman.Game
  
  # test functions
  defdelegate new_game_test(word),    to: Hangman.Game
  
end
