defmodule Hangman.Struct do
  defstruct(
    game_state: :initializing,
    turns_left: 7,
    word:       [],
    letters:    [],
    used:       [],
    last_guess: ""
  )
end
