defmodule Hangman do
  @moduledoc """
  API for Hangman.
  """

  defdelegate new_game,               to:Hangman.Impl
  defdelegate tally(game),            to:Hangman.Impl
  defdelegate make_move(game, guess), to:Hangman.Impl


  end
end
