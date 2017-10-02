defmodule Hangman.Helper do
  # Implementation for Hangman Helper.

  def get_letters(word, used) do
    word
    |> String.codepoints
    |> Enum.map(&(letter(&1, &1 in used)))
  end

  def letter(_, false), do: "_"
  def letter(letter, true), do: letter

  def get_state(true), do: :good_guess
  def get_state(false), do: :bad_guess
  def get_state(word, guess) do
    String.contains?(word, guess)
    |> get_state
  end

  def valid_guess(guess) do
    guess
    |> String.match?(~r/^[A-Za-z]$/)
  end

end
