defmodule Hangman.Game do

  defmodule State do

    #Struct for the state of the game

    defstruct(
      word:             "" ,
      game_state:       :initializing,
      turns_left:       7,
      letters:          [],
      used:             [],
      last_guess:       "",
      left_letters_set: MapSet.new()
    )
  end

  def new_game() do
    init_game()
  end

  def tally(game) do
    game
    |> get_tally()
  end

  def make_move(game, guess) do
    make_move_handler(game, guess)
  end


  ###########################
  # End of public Functions #
  ###########################


  # Time for Private Functions

  ##################################
  # Private Functions for new_game #
  ##################################
  
  # Initilize the state of the game
  defp init_game() do
    word = Dictionary.random_word()
    %State{ word: word, left_letters_set: word |> get_letters_set() }
  end

  # Converts the random word into the MapSet
  defp get_letters_set(word) do
    word
    |> String.codepoints
    |> MapSet.new()
  end

  ###############################
  # Private Functions for tally #
  ###############################

  # Return a map based on the game state and current status of the game
  def get_tally(%State{
                    game_state: state,
                    turns_left: turns_left,
                    last_guess: last_guess,
                    used:       used
                  } = game) do
    %{
      game_state: state,
      turns_left: turns_left,
      used:       used,
      last_guess: last_guess,
      letters:    replace_letters(game, used)
    }
  end

  # Convert the word to list of letters
  defp to_list(word) do
    word
    |> String.codepoints()
    |> Enum.to_list()
  end

  # If lost then return then set the letters as list of word
  defp replace_letters(%State{ game_state: :lost } = game, _) do
    game.word
    |> to_list
  end

  # Set all the letters in the word by an _. Used when game is initialized i.e., when used is empty. 
  defp replace_letters(%State{ word: word }, []) do
    word
    |> String.replace(~r/\w/, "_")
    |> to_list
  end

  # Set the letters that have not yet been guessed by an _ in appropriate positions
  defp replace_letters(%State{ word: word }, used) do
    word
    |> String.replace(~r/[^#{used}]/, "_")
    |> to_list
  end

  ###################################
  # Private Functions for make_move #
  ###################################

  defp is_letter?(letter) do
    letter
    |> String.match?(~r/^[A-Za-z]$/)
  end

  # check if guess is in used and handle the guess accordingly
  defp make_move_handler(%State{ used: used } = game, guess) do
    game = handle_guess(game, guess |> is_letter?(), guess in used, guess)
    { game, game |> tally() }
  end

  # For fun
  defp handle_guess(%State{ game_state: :lost } = game , _, _, _) do
    IO.puts("Game Over! Please start a new game!")
    game
  end

  defp handle_guess(game, false, _, _) do
    IO.puts("Invalid letter entered. Please try again!")
    game
  end

  # If guess is in used, then set state to :already_used
  defp handle_guess(game, true, true, _guess) do
    %State{ game | game_state: :already_used }
  end

  # If guess is not in used, then check if guess is in the set of letters left
  # and handle accordingly
  defp handle_guess(game, true, false, guess) do
    handle_map(game, guess in game.left_letters_set, guess)
  end

  # If guess is in set of letters left then update used and set of left letters 
  # Also has to checked if the game is won and set game_state accordingly
  defp handle_map(game, true, guess) do
    game =  %State{ game |  last_guess:       guess,
                            used:             concat_and_sort(game.used, guess),
                            left_letters_set: MapSet.delete(game.left_letters_set, guess) }
    handle_state(game, game.left_letters_set |> MapSet.size())
  end

  # If guess is not in set of letters left then update turns left and used and
  # check if the state is :bad_guess or :lost
  defp handle_map(game, false, guess) do
    game = %State{ game | turns_left: game.turns_left - 1,
                          used:       concat_and_sort(game.used, guess),
                          last_guess: guess }
    handle_turns(game, game.turns_left)
  end

  # Helper function to add and sort the list of used letters
  defp concat_and_sort(used, guess) do
    used ++ [guess]
    |> Enum.sort()
  end

  # If number of turns is zero, then set the game_state to :lost and update letters
  defp handle_turns(game, 0) do
    %State{ game |  game_state: :lost,
                    letters:    game.word |> String.codepoints() }
  end

  # If number of turns is greater than 0, then set the game_state to :bad_guess
  defp handle_turns(game, turns) when turns > 0 do
    %State{ game | game_state: :bad_guess }
  end

  # Check if the set of letters left is none and set the game_state to :won
  defp handle_state(game, 0) do
    %State{ game | game_state: :won }
  end

  # Check if there are any more in the set of letters left and 
  # set the game_state to :good_guess
  defp handle_state(game, _) do
    %State{ game | game_state: :good_guess }
  end

end

#$$$$$$$$$$$$$#
# End of Game #
#$$$$$$$$$$$$$#
