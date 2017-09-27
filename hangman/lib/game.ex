defmodule State do
    defstruct game_state: :initializing,
     turns_left: 7,
     letters: [],
     used: [],
     word: "",
     last_guess: ""
end

defmodule Hangman.Game do
  @moduledoc """
  Documentation for Hangman.
  """

  def new_game() do
    new_game(Dictionary.random_word())
  end

  # Exists for testing purposes
  def new_game(word) do
    %State{word: word, letters: map_to_letters(word)}
  end

  def tally(game), do: Map.delete(game, :word)

  defp x_or_underscore(x, true), do: x
  defp x_or_underscore(_, false), do: "_"
  defp map_to_letters(word), do: List.duplicate("_", String.length(word))
  defp map_to_letters(word, used) do
     String.graphemes(word) |>
     Enum.map(&(x_or_underscore(&1, &1 in used)))
  end


  defp make_guess(game, _, true, _), do: %{game | game_state: :already_used}

  # Case where the user lost
  defp make_guess(game = %{turns_left: 1, used: used}, guess, false, false) do
    %{game | turns_left: 0, used: used ++ [guess], game_state: :lost}
  end

  # Generic bad guess
  defp make_guess(game = %{used: used, turns_left: turns_left}, guess, false, false) do
    %{game | turns_left: turns_left-1, used: used ++ [guess], game_state: :bad_guess}
  end

    defp make_guess(game = %{used: used, word: word}, guess, false, true) do
      used = used ++ [guess]
      letters = map_to_letters(word, used)
      game |>
      Map.replace(:used, used) |>
      Map.replace(:letters, letters) |>
      check_victory("_" in letters)
    end
  defp check_victory(game, false), do: %{game | game_state: :won}
  defp check_victory(game, true),  do: %{game | game_state: :good_guess}


  # Is this good practice?  Should this fail?
  def make_move(game = %{turns_left: 0}, _) do
    game = %{game | game_state: :lost}
    {game, Hangman.Game.tally(game)}
  end

  def make_move(game = %{used: used, word: word}, guess) do
    game = %{game | last_guess: guess}
    game = make_guess(game, guess, guess in used, String.contains?(word, guess))
    {game, Hangman.Game.tally(game)}
  end

end
