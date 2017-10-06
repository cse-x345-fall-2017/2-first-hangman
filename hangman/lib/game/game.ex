defmodule Hangman.Game do
  def new_game() do 
    # function to filter alphabets
    alphabets_only = fn x -> Regex.match?(~r{[a-zA-Z]}, x) end
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
      last_guess: "",
      letters: letters,
      word: word
    }
  end

  def tally(%State{ game_state: state,
                    turns_left: turns,
                    letters: letters,
                    used: used})
  do
    %{
      game_state: state,
      turns_left: turns,
      letters: letters,
      used: used
    }
  end

  def evaluate(guess, word, letters), do: evaluate(guess,
                                                   word,
                                                   letters,
                                                   [])
  # First alphabet matches guess
  def evaluate(guess, [ guess | word_tail ], [ _alphabet | letters_tail ], letters_new) do
    evaluate(guess, word_tail, letters_tail, letters_new |> Enum.concat([guess]))
  end
  # When the alphabet at the position in word has already been guessed right
  def evaluate(guess, [ alphabet | word_tail ], [ alphabet | letters_tail ], letters_new)
  do
    evaluate(guess, word_tail, letters_tail, letters_new |> Enum.concat([alphabet]))
  end

  # When guess matches the current alphabet
  def evaluate(guess, [ guess | word_tail ], [ "_" | letters_tail ], letters_new)
  do
    evaluate(guess, word_tail, letters_tail, letters_new |> Enum.concat([guess]))
  end

  # When guess does not match the current alphabet
  def evaluate(guess, [ _alphabet | word_tail ], [ "_" | letters_tail ], letters_new)
  do
    evaluate(guess, word_tail, letters_tail, letters_new |> Enum.concat(["_"]))
  end

  # No alphabets left
  def evaluate(_guess, [], _letters, letters_new), do: letters_new
end
