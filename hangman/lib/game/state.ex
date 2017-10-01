defmodule State do
  defstruct game_state: :initializing,
            turns_left: 7,
            letters: [],
            used: [],
            last_guessed: "",
            word: []
end