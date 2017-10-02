defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Hangman.hello
      :world

  """
  defstruct(
    game_state: :initializing,
    turns_left: 7,
    letters: [],
    used: [],
    last_guessed: "",
    word: []
  )

  def new_game() do
    word = Dictionary.random_word()
    word = Regex.split(~r{}, word, trim: true)
    word = List.delete(word, "\r")
    letters = Enum.reduce(word, [], fn (_, acc) -> ["_" | acc] end)
    %Hangman{word: word, letters: letters}
  end
  
  def tally(%Hangman{} = game) do
    Map.drop(game, [:last_guessed, :word])
    |> Map.from_struct
    |> IO.inspect
  end

  def guess_valid?(string) do
    Regex.match?(~r/^[a-zA-Z]$/, string)
  end

  
  defp match_letter(true, _, {letter, _}), do: letter
  defp match_letter(false, letters, {_, index}), do: Enum.fetch!(letters, index)
  
  defp match_guess(false, false), do: :bad_guess
  defp match_guess(true, false), do: :good_guess
  defp match_guess(_, true), do: :already_used
  
  defp handle_result(:bad_guess, guess, state) do
    #Enum.reduce(state.word)
    %Hangman{state | game_state: :bad_guess, last_guessed: guess, turns_left: state.tally-1}
  end
  
  defp handle_result(:good_guess, guess, state) do
    %Hangman{state | game_state: :bad_guess, last_guessed: guess, turns_left: state.tally-1}
    #add to used list
  end

  def make_move(%Hangman{} = game, string) do
  
    #catch invalid entry
    true = guess_valid?(string)
    
    match_guess(MapSet.new(game.word) |> MapSet.member?(string),
                MapSet.new(game.used) |> MapSet.member?(string))

   #handle_result(:good_guess, string, %Hangman{} = game)

  end
end
