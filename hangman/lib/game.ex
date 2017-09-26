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

  def tally(game) do
    %{
      game_state: game.game_state
    }
  end

  def make_move(game = %{used: used}, guess) do
    {%{game | game_state: :already_used}, Hangman.Game.tally(game)}
  end

  def make_move(game = %{target: target}, guess) do
    {game, Hangman.Game.tally(game)}
  end
end
