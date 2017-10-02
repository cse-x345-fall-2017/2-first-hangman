defmodule GameState do
  defstruct game_state: :initializing,
  letters: [],
  turns_left: 7,
  word:"",
  last_guess: "",
  used: [],

end



defmodule Game do

  def new_game() do
    new_game(Dictionary.random_word())
  end

  def tally(game) do
    Map.delete(game, :word)
  end

  #Mark the progress of guesses
  defp mark(_, false), do: "_"
  defp mark(x, true), do: x

  #keep track of turns
  defp turn_taken(game) do
    Map.update(game, :turns_left, &(&1 -1))
  end

  #Mapping of the word to letters
  defp set_letters(word) do
    List.duplicate("_", String.length(word))
  end

  defp set_letters(word, used) do
    String.graphemes(word) |>
    Enum.map(&(mark(&1, &1 in used))
  end

  #Patern Matching for Guesses
  #Good Guess
  defp guess( game = %{used: used, word: word}, guess, false, true) do
    used = used ++ [guess]
    letters = set_letters(word, used)
    game = Map.replace(:used, used)
    game = Map.replace(:letters, letters)
    win_or_lose("_" in letters)
  end

  #Bad Guess
  defp guess(game = %{used: used}, guess, false, false) do
    %{turn_taken(game) | used: used ++ [guess], game_state: :bad_guess}
  end

  #Game Status Check
  defp win_or_lose(game, false) do
    %{game | game_state: :won}
  end



  def make_move(game = %{used: used, word: word}, guess) do
    game = %{game | last_guess: guess}
    game = guess(game, guess, guess in used, String.contains(word, guess))
    {game, Hangman.Game.tally(game)}
  end


end
