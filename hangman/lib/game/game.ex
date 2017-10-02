defmodule Hangman.Game do
  def new_game() do
    # function to filter alphabets
    alphabets_only = fn x -> if Regex.match?(~r{[a-zA-Z]}, x),
                               do: true,
                               else: false
                            end

    # Get a random word from dictionary and store it as a list of characters
    word = Dictionary.random_word()
            |> String.split("")
            |> Enum.filter(alphabets_only)

    # Initialize the progress as blanks
    letters =  Enum.map(word, fn _letter  -> "_" end)

    %State{
      game_state: :initializing,
      turns_left: 7,
      used: [],
      last_guessed: [],
      letters: letters,
      word: word
    }
  end

  def tally(game) do
    game
      |> Map.from_struct()
      |> Map.drop([:word, :last_guessed])
  end
end
