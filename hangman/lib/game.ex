defmodule State do
    defstruct game_state: :initializing,
     turns_left: 7,
     letters: [],
     used: [],
     target: "",
     last_guess: ""
end

defmodule Hangman.Game do
  @moduledoc """
  Documentation for Hangman.
  """

  def new_game() do
    word = Dictionary.random_word()
    %State{
      target:  word,
      letters: List.duplicate("_", String.length(word))
    }
  end

  # Exists for testing purposes
  def new_game(word) do
    %State{
      target:  word,
      letters: List.duplicate("_", String.length(word))
    }
  end

  def tally(%{game_state: game_state}) do
    %{game_state: game_state}
  end

  defp bad_guess(game = %{used: used, turns_left: turns_left}, guess) do
    %{game | turns_left: turns_left-1, used: used ++ [guess], game_state: :bad_guess}
  end

  def make_move(game = %{turns_left: 0}, guess) do
    {game, Hangman.Game.tally(game)}
  end

  def make_move(game = %{used: used, target: target}, guess) do
    cond do
      guess in used ->
        game = %{game | game_state: :already_used}
      !String.contains?(target, guess) ->
        game = bad_guess(game, guess)
    end
    {game, tally(game)}
  end

end
