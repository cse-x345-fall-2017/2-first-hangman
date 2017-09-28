defmodule Hangman.Game do

    defstruct(
        turns_left: 7, 
        game_status: :initializing,
        word: [],
        hidden: [],
        used: [],
        last_guess: ""
    )

#####################################################################

    def new_game() do
        new_word = get_word()

        %Hangman.Game{
            word: new_word, 
            hidden: get_hidden(new_word)
        }
    end

    defp get_word() do
        Dictionary.random_word()
        |> String.trim("\r")
        |> String.graphemes()
    end

    defp get_hidden(word) do
        List.duplicate("_",length(word))
    end

#####################################################################

    def tally(game) do 
        %{game_status: status, turns_left: left, hidden: h,
            used: u, last_guess: g} = game

        %{game_state: status, turns_left: left, letters: h,
            used: u, last_guess: g}
    end

#####################################################################

    def make_move(game, guess) do
        %{word: w, hidden: h, used: u} = game
        found_i = Enum.map(w, fn(letter) -> letter == guess end)

        Map.put(%{game | 
            game_status: check_stat(game,found_i),
            turns_left: check_turns(found_i),
            hidden: check_hidden(h,found_i),
            used: [u | guess],
            last_guess: guess
            })
    end

    defp check_stat(game, found_i) do

    end

    defp check_turns(found_i) do

    end

    defp check_hidden(hidden, found_i) do

    end

end