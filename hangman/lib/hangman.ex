defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  @doc """
  New game
  Initializes a new game of Hangman with a random word
  """
  defdelegate new_game(), to: Hangman.Impl

  @doc """
  Tally returns a map representing the current state of the game
  %{
    game_state:   atom representing the current status
    turns_left:   # of turns left in the game
    letters:      the letters of the word to guess
                  with not guessed replaced with "_"
    used:         sorted list of the letters that have been guessed
    last_guess: last guessed letter 
   }
  """
  defdelegate tally(game), to: Hangman.Impl

  @doc """
    make move takes the current game and a guess and returns a tuple
    containing the updated game state and the current tally

  ## Examples
    iex> Hangman.make_move %Hangman.Game{game_state: :initializing, last_guess: "", letters: ["c", "a", "t"], turns_left: 7, used: []}, "a"
    {%Hangman.Game{game_state: :good_guess, last_guess: "a",
             letters: ["c", "a", "t"], turns_left: 7, used: ["a"]},
            %{game_state: :good_guess, last_guess: "a",
              letters: ["_", ["a", ["_", []]]], turns_left: 7, used: ["a"]}}
  """
  defdelegate make_move(game, guess), to: Hangman.Impl
end
