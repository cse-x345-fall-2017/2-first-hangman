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
    get_tally(game)
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
  
  defp init_game() do
    word = Dictionary.random_word()
    %State{ word: word, left_letters_set: get_word_set(word) }
  end

  defp get_word_set(word) do
    word
    |> String.codepoints
    |> MapSet.new()
  end

  ###############################
  # Private Functions for tally #
  ###############################

  def get_tally(%State{
                    game_state:       state,
                    turns_left:       turns_left,
                    last_guess:       last_guess,
                    used:             used
                  } = game) do
    %{
      game_state: state,
      turns_left: turns_left,
      used:       used,
      last_guess: last_guess,
      letters:    replace_letters(game, used)
    }
  end

  defp to_list(word) do
    word
    |> String.codepoints()
    |> Enum.to_list()
  end

  defp replace_letters(%State{ game_state: :lost} = game, _) do
    game.word
    |> to_list
  end

  defp replace_letters(%State{ word: word }, []) do
    word
    |> String.replace(~r/\w/, "_")
    |> to_list
  end

  defp replace_letters(%State{ word: word}, used) do
    word
    |> String.replace(~r/[^#{used}]/, "_")
    |> to_list
  end

  ###################################
  # Private Functions for make_move #
  ###################################

  defp make_move_handler(%State{ used: used } = game, guess) do
    handle_guess(game, guess in used, guess)
  end

  defp handle_guess(game, true, _guess) do
    game = %State{ game | game_state: :already_used }
    { game, tally(game) }
  end

  defp handle_guess(game, false, guess) do
    handle_map(game, guess in game.left_letters_set, guess)
  end

  defp handle_map(game, true, guess) do
    game =  %State{ game |  last_guess:       guess,
                            used:             game.used ++ [guess] |> Enum.sort,
                            left_letters_set: MapSet.delete(game.left_letters_set, guess)
            }
    handle_state(game, MapSet.size(game.left_letters_set))
  end

  defp handle_map(game, false, guess) do
    game = %State{ game | turns_left: game.turns_left - 1,
                          used:       game.used ++ [guess] |> Enum.sort,
                          last_guess: guess
           }
    handle_turns(game, game.turns_left)
  end

  defp handle_turns(game, 0) do
    game = %State{ game | game_state: :lost,
                          letters: game.word |> String.codepoints()
           }
    { game, tally(game) }
  end

  defp handle_turns(game, turns) when turns > 0 do
    game = %State{ game | game_state: :bad_guess }
    { game, tally(game) }
  end

  defp handle_turns(_game, _turns) do
    IO.puts("You have lost all your turns! Please start a new game to play again.")
  end

  defp handle_state(game, 0) do
    game = %State{ game | game_state: :won }
    { game, tally(game) }
  end

  defp handle_state(game, _) do
    game = %State{ game | game_state: :good_guess }
    { game, tally(game) }
  end

end
