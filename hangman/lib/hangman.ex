defmodule Hangman do

  # Interface for Hangman Game

  defdelegate new_game(),             to: Hangman.Impl
  defdelegate tally(game),            to: Hangman.Impl
  defdelegate make_move(game, guess), to: Hangman.Impl
end
