defmodule GameState do
    defstruct( 
        game_state: :initializing,
        turns_left: 7,
        letters: [],
        used: MapSet.new,
        last_guess: "",
        hangman_word: []
    )
end