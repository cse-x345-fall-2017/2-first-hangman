defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  defstruct turns_left: 7, game_state: :initializing,
            word: "", used: [], last_guess: ''

  def new_game do
    %Hangman{ word: Dictionary.random_word() }
  end
end
