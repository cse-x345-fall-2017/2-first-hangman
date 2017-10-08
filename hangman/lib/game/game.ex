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

  def fill_occurences(guess, game) do 
    result = fill_occurences(guess, game.word, game.letters, [])
    { %State{ game | letters: result}, result, game.letters }
  end

  # First alphabet matches guess
  def fill_occurences(guess, [ guess | word_tail ], [ _alphabet | letters_tail ], result) do
    fill_occurences(guess, word_tail, letters_tail, result |> Enum.concat([guess]))
  end
  # When the alphabet at the position in word has already been guessed right
  def fill_occurences(guess, [ alphabet | word_tail ], [ alphabet | letters_tail ], result)
  do
    fill_occurences(guess, word_tail, letters_tail, result |> Enum.concat([alphabet]))
  end

  # When guess matches the current alphabet
  def fill_occurences(guess, [ guess | word_tail ], [ "_" | letters_tail ], result)
  do
    fill_occurences(guess, word_tail, letters_tail, result |> Enum.concat([guess]))
  end

  # When guess does not match the current alphabet
  def fill_occurences(guess, [ _alphabet | word_tail ], [ "_" | letters_tail ], result)
  do
    fill_occurences(guess, word_tail, letters_tail, result |> Enum.concat(["_"]))
  end

  # No alphabets left
  def fill_occurences(_guess, [], _letters, result), do: result
  
  def give_feedback(_letters, _letters, game) do
    on_bad_guess(game.turns_left, game)
  end
  def give_feedback(_letters_new, _letters, game) do
    on_good_guess(game.letters, game.word, game)
  end

  def on_good_guess(word, word, game), do: %State{ game | game_state: :won}
  def on_good_guess(_letters, _word, game) do
    %State{ game | game_state: :good_guess}
  end

  def on_bad_guess(1, game), do: %State{ game | game_state: :lost}
  def on_bad_guess(turns_left, game) do
    %State{ game | turns_left: turns_left-1, game_state: :bad_guess}
  end

  # def wordify(letters), do: [Enum.join(letters, "")]
end
