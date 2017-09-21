defmodule Hangman.Game do

  # game structure
  defstruct \
    game_state: :initializing, 
    word: "", 
    last_guess: "",
    turns_left: 7, 
    word_chars: [],
    letters: [], 
    used: []

    
  # === PUBLIC FUNCTIONS ===================================================== #
    
    
  # create a new game
  def new_game do
    word = Dictionary.random_word()
      |> String.trim() # "\r" is showing up on my windows machine, so remove it
      
    %Hangman.Game{
      word:        word,
      letters:     init_letters(word),
      word_chars:  String.codepoints(word)
    }
  end
  
  
  # return the current tally of the game
  def tally(game) do
    %{
      game_state:  game.game_state,
      turns_left:  game.turns_left,
      last_guess:  game.last_guess,
      letters:     game.letters,
      used:        Enum.sort(game.used)  # put in alphabetical order
    }
  end
  
  
  # handle a move made by the game player
  def make_move(game, guess) do
    new_game = evaluate_guess(game, guess, guess in game.used)
    { new_game, new_game |> tally() }
  end
  
  
  # === PRIVATE FUNCTIONS ==================================================== #
  
  
  # handle a move with an already used guess
  defp evaluate_guess(game, _guess, _already_used = true) do 
    %{game | game_state: :already_used}
  end
  
  # handle a move with a new guess
  defp evaluate_guess(game, guess, _new_guess) do
    handle_new_guess(game, guess, guess in game.word_chars)
  end
  
  
  # handle a correct new guess
  defp handle_new_guess(game, guess, _correct_guess = true) do
    game_update = %{ 
      game |
        game_state:  :good_guess,
        last_guess:  guess,
        letters:     reveal_letters(game, guess),
        used:        [guess | game.used]
    }
    check_if_won(game_update, "_" not in game_update.letters)
  end
  
  # handle an incorrect new guess
  defp handle_new_guess(game, guess, _incorrect_guess) do
    game_update = %{
      game |
        game_state:  :bad_guess,
        last_guess:  guess,
        turns_left:  game.turns_left - 1,
        used:        [guess | game.used]
    }
    check_if_lost(game_update, 0 == game_update.turns_left)
  end
  
  
  # check if the user won
  defp check_if_won(game, _all_guessed = true), do: %{game | game_state: :won}
  defp check_if_won(game, _),                   do: game
  
  
  # check if the user lost the game
  defp check_if_lost(game, _no_turns_left = true) do
    %{
      game | 
        game_state:  :lost, 
        letters:     game.word_chars  # fill in all letters
    }
  end
  defp check_if_lost(game, _), do: game
  
  
  # initialize the game letters
  defp init_letters(word) do
    String.codepoints(word)
      |> Enum.map(fn (_char) -> "_" end) # replace all with underscore
  end
  
  
  # reveal letters that match the guess
  def reveal_letters(game, guess) do
    game.word_chars
      |> letter_match(game.letters, guess)
  end
  
  
  # helper function to change letters that match the guess
  defp letter_match([],       [],        _g), do: []
  defp letter_match([g | t1], ["_" | t2], g), do: [g  | letter_match(t1, t2, g)]
  defp letter_match([_ | t1], [h2  | t2], g), do: [h2 | letter_match(t1, t2, g)]
  
end
