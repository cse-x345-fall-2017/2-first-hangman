defmodule Hangman.Game do
  defstruct(
    game_state: :initializing,
    turns_taken: 0,
    turns_left: 7,
    word: "",
    used: [],
    last_guessed: ""
  )
end