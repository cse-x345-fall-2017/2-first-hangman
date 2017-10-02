defmodule Hangman do
  @moduledoc """
  The Hangman module provides a set of exposed functions that are then delegated
  to Hangman.Game
  """

  defdelegate new_game(), to: Hangman.Game
  defdelegate new_game(word), to: Hangman.Game
  defdelegate tally(game), to: Hangman.Game
  defdelegate make_move(game, guess), to: Hangman.Game

end
