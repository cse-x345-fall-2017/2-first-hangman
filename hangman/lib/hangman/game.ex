defmodule Hangman.Game do
  @moduledoc """
  Documentation for Hangman.
  """

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

  defp decrement(x) do
    x - 1
  end

  defp update_if_won(state, true) do
    %{ state | game_state: :won }
  end
  defp update_if_won(state, false) do
    state
  end

  defp letter_display(letter, true) do
    letter
  end
  defp letter_display(_, false) do
    "_"
  end

  defp update_letters(state) do
    letters = state.word
    |> String.codepoints
    |> Enum.map(&(letter_display(&1, &1 in state.used)))
    Map.put(state, :letters, letters)
  end

  defp update_state(state, letter) do
    state = state
    |> Map.put(:used, [ letter | state.used])
    |> Map.put(:last_guess, letter)
    |> update_letters

    won = Enum.all?(state.letters, &(&1 != "_"))
    state |> update_if_won(won)
  end


  # No turns left
  def make_move(state=%{ turns_left: 0 }, _, _, _) do
    %{ state | game_state: :lost }
  end
  # Letter already used
  def make_move(state, _, _, true) do
    %{ state | game_state: :already_used }
  end
  # Last turn and letter not in word
  def make_move(state=%{ turns_left: 1 }, _, false, _) do
    %{ state | game_state: :lost, turns_left: 0,
               letters: String.codepoints(state.word)}
  end
  # Letter not in word
  def make_move(state, letter, false, _) do
    %{ state | game_state: :bad_guess }
    |> Map.update!(:turns_left, &decrement/1)
    |> update_state(letter)
  end
  # Letter in word
  def make_move(state, letter, true, _) do
    state = %{ state | game_state: :good_guess }
    |> update_state(letter)
  end
  def make_move(state, letter) do
    letter_in_word = letter in String.codepoints(state.word)
    letter_in_used = letter in state.used
    state =  make_move(state, letter, letter_in_word, letter_in_used)
    { state, tally(state) }
  end

end
