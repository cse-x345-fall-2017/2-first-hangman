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
      last_guess: "",
      letters: letters,
      word: word
    }
  end

  def tally(game) do
    game
      |> Map.from_struct()
      |> Map.drop([:word])
  end

  def make_move(game, guess) do
    if Enum.member?(game.used, guess) do
      game = %State{ game |
        game_state: :already_guessed
      }
      { game, tally(game) }
    else
      make_move(game, guess, :new_guess)
    end
  end
  def make_move(game, guess, _new_guess) do
    used = Enum.concat(game.used, [guess])
    letters_after = check(game.word, guess, game.letters)
    
    letters_changed? = letters_after !=  game.letters
    won? = letters_after == game.word

    
    { game_state, turns_left } = update_if(letters_changed?,
                                           game.turns_left,
                                           won?)

    # Letters represents entire word if won or lost
    letters_after = if [:won, :lost] |> Enum.member?(game_state)
                    do
                      [Enum.join(game.word, "")]
                    else
                      letters_after
                    end

    updated_game = %State{ game | used: used,
                                  letters: letters_after,
                                  game_state: game_state,
                                  turns_left: turns_left,
                                  last_guess: guess }
    { updated_game, tally(updated_game) }
  end

  # Returns updated values of turns and game state
  def update_if(_letters_changed?, turns_left, true), do: { :won, turns_left }
  def update_if(true, turns_left, _won), do: { :good_guess, turns_left }
  def update_if(false, 1, _won), do: { :lost, 0 }
  def update_if(false, turns_left, _won), do: { :bad_guess, turns_left-1 }

  # Compares guess with word to update letters
  def check(word, guess, letters), do: check(word, guess, letters, 0)
  def check([ guess | tail ], guess, letters, index) do
    letters_new = List.replace_at(letters, index, guess)
    check(tail, guess, letters_new, index+1)
  end
  def check([ _head | tail ], guess, letters, index) do
    check(tail, guess, letters, index+1)
  end
  def check([], _guess, letters, _index), do: letters
end
