defmodule GameState do
    defstruct( 
        game_state: :initializing,
        turns_left: 7,
        letters: [],
        used: [],
        last_guess: "",
        hangman_word: []
    )
end