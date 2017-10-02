defmodule Hangman.Init do
  
  def new_game() do
    new_letters = Dictionary.random_word()
    |> String.trim()
    |> String.codepoints()
    %Hangman.Struct{word: new_letters, letters: List.duplicate("_", length(new_letters))}
  end
end
