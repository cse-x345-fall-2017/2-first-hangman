defmodule State do
    defstruct game_state: :initializing,
     turns_left: 7,
     letters: [],
     used: [],
     target: ""
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

  end

  def make_move(game, guess)do
    {1, 2}
  end

end
