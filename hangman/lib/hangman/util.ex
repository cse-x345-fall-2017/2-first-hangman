defmodule Hangman.Util do
  @moduledoc """
  This module includes utility functions for updating
  the game's state
  """

  @doc """
  Decrement x by 1
  """
  def decrement(x) do
    x - 1
  end

  @doc """
  Return true if game won (all letters guessed)
  """
  def won?(state) do
    Enum.all?(state.letters, &(&1 != "_"))
  end

  @doc """
  Update the state of the game to :won if won is true
  """
  def update_if_won(state, true) do
    %{ state | game_state: :won }
  end
  def update_if_won(state, false) do
    state
  end

  @doc """
  Return the letter if true, else display an underscore.

  Used in representing the current word, with guesses filled in.
  """
  def letter_display(letter, true) do
    letter
  end
  def letter_display(_, false) do
    "_"
  end

  @doc """
  Update :letters in the state, by filling in any correctly
  guessed letters
  """
  def update_letters(state) do
    letters = state.word
    |> String.codepoints
    |> Enum.map(&(letter_display(&1, &1 in state.used)))
    Map.put(state, :letters, letters)
  end

  @doc """
  Update the state of a game including the letters used,
  the last guess, and the :letters representation of the
  word, and the game state if won
  """
  def update_state(state, letter) do
    state = state
    |> Map.put(:used, [ letter | state.used])
    |> Map.put(:last_guess, letter)
    |> update_letters

    won = won?(state)
    state |> update_if_won(won)
  end


  @doc """
  Update the state of the game, given the letter guessed
  """
  # Invalid letter
  def make_move(_, _, _, _, false) do
    raise ArgumentError, message: "invalid letter"
  end
  # No turns left
  def make_move(state=%{ turns_left: 0 }, _, _, _, _) do
    %{ state | game_state: :lost }
  end
  # Letter already used
  def make_move(state, _, _, true, _) do
    %{ state | game_state: :already_used }
  end
  # Last turn and letter not in word
  def make_move(state=%{ turns_left: 1 }, _, false, _, _) do
    %{ state | game_state: :lost, turns_left: 0,
               letters: String.codepoints(state.word)}
  end
  # Letter not in word
  def make_move(state, letter, false, _, _) do
    %{ state | game_state: :bad_guess }
    |> Map.update!(:turns_left, &decrement/1)
    |> update_state(letter)
  end
  # Letter in word
  def make_move(state, letter, true, _, _) do
    %{ state | game_state: :good_guess }
    |> update_state(letter)
  end

end
