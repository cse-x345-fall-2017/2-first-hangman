defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Hangman.hello
      :world

  """
  def hello do
    :world
  end

  defdelegate new_game(), to: Hangman.Game
  defdelegate tally(game), to: Hangman.Game
end
