defmodule Hangman.Assist do
  @moduledoc """
  Implementation of Hangman assist functions
  """

  def split_word(word) do
   String.graphemes(word)
  end
  
  
  #invalid input
  def guess(_, :false, _, _, _, _) do
    raise ArgumentError, message: "Please enter a valid input!"
  end

  #zero turns
  # have to put full word into letters at the end or 
  # will not show up in human_player (only for loss funcs)

  def guess(game, :true, _, _, _, 0) do
    %{ game | game_state: :lost }
    |> Map.put(:letters, String.split(game.word))
  end

  #one turn and word is wrong
  def guess(game, :true, _, _, :false, 1) do
    %{ game | game_state: :lost }
    |> Map.put(:letters, String.split(game.word))  
  end

  #repeat letter
  def guess(game, :true, _, :true, _, _) do
    %{ game | game_state: :letter_repeat }
  end

  #letter not in word
  def guess(game, :true, letter, :false, :false, turn) do
    %{ game | game_state: :bad_guess, turns_left: turn - 1 }
    |> Map.put(:last_guess, letter)
    |> Map.put(:used, [letter | game.used])
  end

  #letter in word
  def guess(game, :true, letter, :false, :true, turn) do
    %{ game | game_state: :good_guess, turns_left: turn }
    |> Map.put(:last_guess, letter)
    |> Map.put(:used, [letter | game.used])
    |> correct_letter(letter)
  end

  #replaces correct letter with _
  defp correct_letter(game, letter) do
    new_letters = game.word
    |> String.graphemes
    |> Enum.map(&(letter_check(&1, &1 in game.used)))
    game |>
    Map.replace(:letters, new_letters) |>
    end_check("-" in new_letters)
  end

  #singular letter check
  defp letter_check(l, true), do: l
  defp letter_check(_, false), do: "-"

  #checks if win
  defp end_check(game, false), do: %{ game | game_state: :won }
  defp end_check(game, true), do: game
end
