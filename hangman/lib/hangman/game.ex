defmodule Hangman.Game do

  defstruct game_state: :initializing,   # :won | :lost | :already_used | :good_guess | :bad_guess | :initializing
            turns_left: 7,               # the number of turns left (game starts with 7)
            letters: [],                 # a list of single character strings. If a letter in a particular
                                         # position has been guessed, that letter will appear in `letters`. 
                                         # Otherwise, it will be shown as an underscore
            used: [],                    # A sorted list of the letters already guessed
            last_guess: "",               # the last letter guessed by the player
            word: ""                     # the secret word attempting to be guessed

  def new_game() do
    word = Dictionary.random_word
    %Hangman.Game{
      word: word,
      letters: List.duplicate("_", String.length(word))
    }
  end

  def tally(game) do
    game
    |> Map.from_struct
    |> Map.delete(:word)
  end
    
end