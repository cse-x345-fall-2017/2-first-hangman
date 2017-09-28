defmodule Hangman.Game do

    defstruct(
        turns_left: 7, 
        game_status: :initializing,
        word: [],
        hidden: [],
        used: []
    )

    def new_game() do
        new_word = getWord()

        %Hangman.Game{
            word: new_word, 
            hidden: getHidden(new_word)
        }
    end

    defp getWord() do
        Dictionary.random_word()
        |> String.trim("\r")
        |> String.graphemes()
    end

    defp getHidden(word) do
        List.duplicate("_",length(word))
    end


    def tally(game) do 
        %{game_status: status, turns_left: left, hidden: h, used: u} = game
        %{game_status: status, turns_left: left, hidden: h, used: u}
    end

end