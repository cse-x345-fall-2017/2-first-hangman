defmodule Hangman.Game do
  @moduledoc """
  Implemnation of Hangman API.
  """

  #file with helper methods
  import Hangman.Assist

  #state structure
  defstruct turns_left: 7,
            game_state: :initializing,
            letters: [],
            used: [],
            word: "",
            last_guess: ""
  
  #new_game() method that takes a random word and uses it  
  def new_game() do
    word = Dictionary.random_word()
    %Hangman.Game{}
    |> Map.put(:word, word)
    |> Map.put(:letters, List.duplicate("-", String.length(word)))
  end

  #tally method that returns state without word
  def tally(game), do: Map.from_struct(game) |> Map.delete(:word)

  #main function of the API, does all the movement and work
  def make_move(game, move) do
    turns_left = game.turns_left
    valid = String.match?(move, ~r/^[a-z]$/)
    used_letters = move in game.used
    word_letters = String.contains?(game.word, move)
    game = guess(game, valid, move, used_letters, word_letters, turns_left)
    { game, Hangman.Game.tally(game) }
  end

end
