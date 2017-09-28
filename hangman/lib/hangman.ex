defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  defstruct turns_left: 7, game_state: :initializing,
            word: "", used: [], last_guess: '', letters: []

  def new_game do
    word = Dictionary.random_word()
    letters = for _ <- String.codepoints(word), do: "-"
    %Hangman{}
    |> Map.put(:word, word)
    |> Map.put(:letters, letters)
  end

  def tally(state) do
    state |> Map.from_struct |> Map.delete(:word)
  end

  def make_move(state, letter) do
    # Decrease turns_left,
    # add letter to used
    # add letter to last_guess
    # update letters
    # update game_state
    letter_in_word? = letter in String.codepoints(State.word)
    state
    |> Map.update!(:turns_left, &(&1 - 1))
  end

  def update_state(state, letter, true) do

  end
  def update_state(state, letter, false) do

  end

  def word_to_letters(word, used) do
    word |> String.codepoints |> Enum.map(&(if &1 in used do &1 else "_" end))
  end
end
