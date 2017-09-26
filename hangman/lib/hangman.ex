defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  @doc """
  New game
  Initializes a new game of Hangman

  ## Examples

      iex> Hangman.new_game
      %Hangman.Game{game_state: :initializing, last_guessed: "", letters: [],
                    turns_left: 7, turns_taken: 0, used: [], word: ""}

  """
  defdelegate new_game(), to: Hangman.Impl

  @doc """
  Tally sums the score of the hangman game
  Initializes a new game of Hangman
  """
  defdelegate tally(game), to: Hangman.Impl
  defdelegate make_move(game, guess), to: Hangman.Impl
end
