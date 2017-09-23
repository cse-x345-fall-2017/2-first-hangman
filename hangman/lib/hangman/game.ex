defmodule Hangman.Game do

  # game state structure
  defmodule GameState do
  
    defstruct(
      game_state:  :initializing, 
      last_guess:  "",             # last guess by the player
      turns_left:  7,              # number of turns left
      answers:     [],             # answers to all letters
      letters:     [],             # correctly guess letters
      used:        []              # all letteres used for guesses
   )
   
  end

    
  # === PUBLIC FUNCTIONS ===================================================== #
    
    
  # create a new game
  def new_game do
    word = Dictionary.random_word()
      |> String.trim() # "\r" is showing up on my windows machine, so remove it
      
    %GameState{
      letters:  init_letters(word),
      answers:  String.codepoints(word)
    }
  end
  
  
  # return the current tally of the game
  def tally(game = %GameState{}) do
    %{
      game_state:  game.game_state,
      turns_left:  game.turns_left,
      last_guess:  game.last_guess,
      letters:     game.letters,
      used:        Enum.sort(game.used)  # put in alphabetical order
    }
  end
  
  
  # handle a move made by the game player
  def make_move(game = %GameState{}, guess) do
    new_game = evaluate_guess(game, guess, guess in game.used)
    { new_game, new_game |> tally() }
  end
  
  
  # === PRIVATE FUNCTIONS ==================================================== #
  
  
  # handle a move with an already used guess
  defp evaluate_guess(game, _guess, _already_used = true) do 
    %{ game | game_state: :already_used }
  end
  
  # handle a move with a new guess
  defp evaluate_guess(game, guess, _new_guess) do
    handle_new_guess(game, guess, guess in game.answers)
  end
  
  
  # handle a correct new guess
  defp handle_new_guess(game, guess, _correct_guess = true) do
    game
      |> update_game_state(guess, :good_guess, game.turns_left)
      |> reveal_letters(guess)
      |> check_if_won()
  end
  
  # handle an incorrect new guess
  defp handle_new_guess(game, guess, _incorrect_guess) do
    game
      |> update_game_state(guess, :bad_guess, game.turns_left - 1)
      |> check_if_lost()
  end
  
  
  # update the game state
  defp update_game_state(game, guess, state, turns) do
    %{ game |
         game_state:  state,
         last_guess:  guess,
         used:        [guess | game.used],
         turns_left:  turns
    }
  end
  
  
  # check if the user won
  defp check_if_won(game = %{answers: same, letters: same}) do
    %{ game | game_state: :won }
  end
  
  defp check_if_won(game) do  # not won yet
    game
  end
  
  
  # check if the user lost the game
  defp check_if_lost(game = %{turns_left: 0}) do
    %{ game | 
         game_state:  :lost, 
         letters:     game.answers  # fill in all letters
    }
  end
  
  defp check_if_lost(game) do  # not lost yet
    game
  end
  
  
  # initialize the game letters
  defp init_letters(word) do
    String.codepoints(word)
      |> Enum.map(fn (_char) -> "_" end) # replace all with underscore
  end
  
  
  # reveal letters that match the guess
  def reveal_letters(game, guess) do
    %{ game | letters: letter_match(game.answers, game.letters, guess) }
  end
  
  
  # helper function to change letters that match the guess
  defp letter_match([],       [],      _g), do: []
  defp letter_match([g | t1], [_ | t2], g), do: [g | letter_match(t1, t2, g)]
  defp letter_match([_ | t1], [u | t2], g), do: [u | letter_match(t1, t2, g)]
  
end
