defmodule Hangman.Impl do
  def new_game() do
    %Hangman.Game{%Hangman.Game{} | word: Dictionary.random_word }
  end

  def tally(game = %Hangman.Game{}) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: String.codepoints(game.word) , #todo: swap letters with underscores
      used: game.used,
      last_guessed: game.last_guessed
    }
  end

  def make_move(game = %Hangman.Game{}, guess) do
    #check if guess is 
    {%Hangman.Game{game | last_guessed: guess, turns_left: game.turns_left - 1}, tally(game)}
  end

  defp hide_chars([head| tail], used_letters) when head in used_letters do
    [head, hide_chars(tail, used_letters)]
  end

  defp hide_chars([head| tail], used_letters) do
    ["_", hide_chars(tail, used_letters)]
  end

  defp hide_chars([], _used_letters) do
    []
  end
end