defmodule Hangman.Helper do
  # Implementation for Hangman Helper.

  def get_letters(word, used) do
    word
    |> String.codepoints
    |> Enum.map(&(letter(&1, &1 in used)))
  end

  def letter(_, false), do: "_"
  def letter(letter, true), do: letter



end
