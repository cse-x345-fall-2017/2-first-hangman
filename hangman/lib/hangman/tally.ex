defmodule Hangman.Tally do
  def tally(game = %Hangman.Struct{}) do
    game
    |> Map.delete(:word)
    |> Map.delete(:__struct__)
  end

  def tally(_) do
    # when fed invalid data
    raise RuntimeError, message: "Invalid parameter here :( try a Hangman.Struct!"
  end
  
end
