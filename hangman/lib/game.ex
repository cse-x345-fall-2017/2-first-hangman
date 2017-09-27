defmodule State do
    defstruct game_state: :initializing,
     turns_left: 7,
     letters: [],
     used: [],
     target: "",
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
    %State{target: word, letters: List.duplicate("_", String.length(word))}
  end

  def tally(game), do: Map.delete(game, :target)

  # Case where the user lost
  defp bad_guess(game = %{turns_left: 1, used: used}, guess) do
    %{game | turns_left: 0, used: used ++ [guess], game_state: :lost}
  end

  # Generic bad guess
  defp bad_guess(game = %{used: used, turns_left: turns_left}, guess) do
    %{game | turns_left: turns_left-1, used: used ++ [guess], game_state: :bad_guess}
  end

  def x_or_underscore(x, true), do: x
  def x_or_underscore(_, false), do: "_"
  defp map_to_letters_or_underscore(x, used),do: x_or_underscore(x, x in used)

  defp good_guess(game = %{used: used, target: target}, guess) do
    used = used ++ [guess]
    letters = Enum.map(String.graphemes(target), fn(x) -> map_to_letters_or_underscore(x, used) end)
    cond do
      "_" in letters ->
        %{game | used: used, letters: letters, game_state: :good_guess}
      true ->
        %{game | used: used, letters: letters, game_state: :won}
    end
  end

  # Is this good practice?  Should this fail?
  def make_move(game = %{turns_left: 0}, _) do
    game = %{game | game_state: :lost}
    {game, Hangman.Game.tally(game)}
  end

  def make_move(game = %{used: used, target: target}, guess) do
    game = %{game | last_guess: guess}
    cond do
      guess in used ->
        game = %{game | game_state: :already_used}
        {game, Hangman.Game.tally(game)}

      !String.contains?(target, guess) ->
        game = bad_guess(game, guess)
        {game, Hangman.Game.tally(game)}

      String.contains?(target, guess) ->
        game = good_guess(game, guess)
        {game, Hangman.Game.tally(game)}
    end
  end

end
