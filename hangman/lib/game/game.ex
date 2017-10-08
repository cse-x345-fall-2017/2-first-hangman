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

  def tally(game)
  do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters,
      used: game.used,
      last_guess: game.last_guess
    }
  end

  def make_move(game, guess) do
    make_move(game, guess, Enum.member?(game.used, guess))
  end

  # Character has already been guessed
  def make_move(game, _guess, true) do
    %State{ game | game_state: :already_guessed} |> send_updated_state()
  end

  # Guess is new
  def make_move(game, guess, false) do
    game 
      |> update_guessed(guess)
      |> fill_occurences(guess)
      |> give_feedback()
      |> send_updated_state()
  end

  # Send new state with tally
  def send_updated_state(game), do: { game, tally(game) }

  # Returns a new state with an updated list of used guesses
  def update_guessed(game, guess) do
    include_guess = game.used |> Enum.concat([guess]) |> Enum.sort()
    %State{ game | used: include_guess, last_guess: guess }
  end

  # Fills occurences(if any) of guess in the word
  def fill_occurences(game, guess) do 
    result = fill_occurences(guess, game.word, game.letters, [])
    { %State{ game | letters: result}, result, game.letters }
  end
  # When the alphabet at the position in word has already been guessed right
  def fill_occurences(guess,
                      [ alphabet | word_tail ], 
                      [ alphabet | letters_tail ], 
                      result)
  do
    result = result |> Enum.concat([alphabet])
    fill_occurences(guess, word_tail, letters_tail, result)
  end
  # When guess matches the current alphabet in the word
  def fill_occurences(guess,
                      [ guess | word_tail ],
                      [ _char | letters_tail ],
                      result)
  do
    result = result |> Enum.concat([guess])
    fill_occurences(guess, word_tail, letters_tail, result)
  end
  # When guess does not match the current alphabet
  def fill_occurences(guess,
                      [ _alphabet | word_tail ],
                      [ _char | letters_tail ],
                      result)
  do
    result = result |> Enum.concat(["_"])
    fill_occurences(guess, word_tail, letters_tail, result)
  end
  # No alphabets left to compare in the word
  def fill_occurences(_guess, [], _letters, result), do: result
  
  # Checks if guess results in changes and updates state accordingly
  def give_feedback({ game, letters, letters }) do
    on_bad_guess(game.turns_left, game)
  end
  def give_feedback({ game, _letters_new, _letters }) do
    on_good_guess(game.letters, game.word, game)
  end

  # Feedback helper when guess is right
  def on_good_guess(word, word, game) do
    %State{ game | game_state: :won, letters: wordify(game.word)}
  end
  def on_good_guess(_letters, _word, game) do
    %State{ game | game_state: :good_guess}
  end

  # Feedback helper when guess is wrong
  def on_bad_guess(1, game) do
    %State{ game | game_state: :lost, letters: wordify(game.word)}
  end
  def on_bad_guess(turns_left, game) do
    %State{ game | turns_left: turns_left-1, game_state: :bad_guess}
  end

  # Helper to reduce list of alphabets into a single-word list
  def wordify(letters), do: [Enum.join(letters, "")]
end
