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

  def new_game(),             do: init_game()
  #Only for testing
  def new_game(word),         do: word |> init_game()
  def tally(game),            do: game |> get_tally()
  def make_move(game, guess), do: make_move_handler(game, guess)

  ###########################
  # End of public Functions #
  ###########################

  # Time for Private Functions

  ##################################
  # Private Functions for new_game #
  ##################################
  
  # Initilize the state of the game
  defp init_game(word \\ Dictionary.random_word()) do
    %State{ word:             word,
            left_letters_set: word |> get_letters_set(),
            letters:          replace_letters(word, [])}
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
  def get_tally(game) do
    Map.delete(game, :word)
    |> Map.delete(:left_letters_set)
    |> Map.delete(:__struct__)
  end

  # Set all the letters in the word by an _. Used when game is initialized 
  # i.e., when used is empty.
  defp replace_letters(word, []),  do: List.duplicate("_", String.length(word))

  # Set the letters that have not yet been guessed by an _ in appropriate positions
  defp replace_letters(word, left) do
    String.replace(word, ~r/[#{left}]/, "_") 
    |> String.codepoints
  end

  ###################################
  # Private Functions for make_move #
  ###################################

  defp is_letter?(letter), do: letter |> String.match?(~r/^[A-Za-z]$/)

  # check if guess is in used and handle the guess accordingly
  defp make_move_handler(%State{ used: used } = game, guess) do
    game = update_state(game, guess |> is_letter?(), guess in used, guess)
    { game, game |> tally() }
  end

  # For fun
  defp update_state(%State{ game_state: :lost } = game , _, _, _), do: game

  # If invalid letter entered
  defp update_state(game, false, _, _),                            do: game

  # If guess is in used, then set state to :already_used
  defp update_state(game, true, true, _guess), do: %State{ game | game_state: :already_used }

  # If guess is not in used, then check if guess is in the set of letters left
  # and handle accordingly
  defp update_state(game, true, false, guess)  do
    game = %State{ game | last_guess: guess,
                          used:       concat_and_sort(game.used, guess) }
    handle_state(game, guess in game.left_letters_set, guess)
  end

  # If guess is in set of letters left then update used and set of left letters 
  # Also has to checked if the game is won and set game_state accordingly
  defp handle_state(game, true, guess) do
    game =  %State{ game | left_letters_set: MapSet.delete(game.left_letters_set, guess) }
    won?(game, game.left_letters_set |> MapSet.size())
  end

  # If guess is not in set of letters left then update turns left and used and
  # check if the state is :bad_guess or :lost
  defp handle_state(game, false, _guess) do
    game = %State{ game | turns_left: game.turns_left - 1 }
    lost?(game, game.turns_left)
  end

  # Helper function to add and sort the list of used letters
  defp concat_and_sort(used, guess), do: used ++ [guess] |> Enum.sort()

  # If number of turns is zero, then set the game_state to :lost and update letters
  defp lost?(game, 0), do: %State{ game | game_state: :lost,
                                          letters:    String.codepoints(game.word) }

  # If number of turns is greater than 0, then set the game_state to :bad_guess
  defp lost?(game, turns) when turns > 0, do: %State{ game | game_state: :bad_guess }

  # Check if the set of letters left is none and set the game_state to :won
  defp won?(game, 0), do: %State{ game | game_state: :won,
                                         letters:    String.codepoints(game.word)}

  # Check if there are any more in the set of letters left and 
  # set the game_state to :good_guess
  defp won?(game, _), do: %State{ game |  game_state: :good_guess,
                                          letters:    replace_letters(game.word, MapSet.to_list(game.left_letters_set)) }

end

#$$$$$$$$$$$$$#
# End of Game #
#$$$$$$$$$$$$$#
