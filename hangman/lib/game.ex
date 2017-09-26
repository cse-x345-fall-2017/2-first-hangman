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

  def tally(game) do
    %{
      game_state: game.game_state
    }
  end

  def make_move(game, guess) when guess =~ Map.get(game, :target) do
    new_game = %{
      game
    }
    {game, Hangman.Game.tally(game)}
  end

  def make_move(game, guess) do
    new_game = %{
      game
    }
    {game, Hangman.Game.tally(game)}
  end

end
