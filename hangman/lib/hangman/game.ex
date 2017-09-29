defmodule Hangman.Game do
  @moduledoc """
  Documentation for Hangman.
  """
  import Hangman.Util

  defstruct turns_left: 7, game_state: :initializing,
            word: "", used: [], last_guess: '', letters: []

  def new_game do
    word = Dictionary.random_word()
    letters = for _ <- String.codepoints(word), do: "-"
    %Hangman.Game{}
    |> Map.put(:word, word)
    |> Map.put(:letters, letters)
  end

  def tally(state) do
    state
    |> Map.from_struct
    |> Map.delete(:word)
  end

  def make_move(state, letter) do
    letter_in_word = letter in String.codepoints(state.word)
    letter_in_used = letter in state.used
    state =  make_move(state, letter, letter_in_word, letter_in_used)
    { state, tally(state) }
  end

end
