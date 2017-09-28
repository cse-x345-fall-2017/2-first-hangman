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

  def decrement(x) do
    x - 1
  end

  def update_if_won(state, true) do
    %{ state | game_state: :won }
  end
  def update_if_won(state, false) do
    state
  end

  def letter_display(letter, true) do
    letter
  end

  def letter_display(_, false) do
    "_"
  end

  def update_letters(state) do
    letters = state.word
    |> String.codepoints
    |> Enum.map(&(letter_display(&1, &1 in state.used)))
    Map.put(state, :letters, letters)
  end

  def update_state(state, letter) do
    state
    |> Map.put(:used, [ letter | state.used])
    |> Map.put(:last_guess, letter)
    |> update_letters
  end

  # No turns left
  def _make_move(state=%{ turns_left: 0 }, _, _, _) do
    %{ state | game_state: :lost }
  end

  # Letter already used
  def _make_move(state, _, _, letter_in_used=true) do
    %{ state | game_state: :already_used }
  end

  # Last turn and letter not in word
  def _make_move(state=%{ turns_left: 1 }, letter, letter_in_word=false, _) do
    %{ state | game_state: :lost, turns_left: 0}
  end

  # Letter not in word
  def _make_move(state, letter, letter_in_word=false, _) do
    %{ state | game_state: :bad_guess }
    |> Map.update!(:turns_left, &decrement/1)
    |> update_state(letter)
  end

  # Letter in word
  def _make_move(state, letter, letter_in_word=true, _) do
    state = %{ state | game_state: :good_guess }
    |> update_state(letter)

    won = Enum.all?(state.letters, &(&1 != "_"))
    state |> update_if_won(won)
  end

  def make_move(state, letter) do
    letter_in_word = letter in String.codepoints(state.word)
    letter_in_used = letter in state.used
    state =  _make_move(state, letter, letter_in_word, letter_in_used)
    { state, tally(state) }
  end

end
