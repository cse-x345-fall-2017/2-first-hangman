defmodule Hangman.Impl do
 
  # state of game
  defmodule State do
    defstruct(
      game_state: :initizlizing,
      turns_left: 7,
      letters: [],
      used: [],
      last_guess: "",
      word: "",                               #answer
      word_to_list: []                        #answer string to list
    )
  end

  # returns a struct representing a new game
  def new_game do
    Dictionary.random_word()
    |> String.trim(/r)
    |> initState()                            #helper function
  end

  # returns the tally for the given game
  def tally(%State{} = game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters:    game.letters,
      used:       game.used,
      last_guess: game.last_guess
    }
  end

  # returns a tuple containing the updated game state and a tally
  make_move(%State{} = game, guess) do
    game = handle_answer( game, guess, guess in used, guess in word_to_list )
    { game, %State{game| last_guess: guess} |> tally() }
  end




  ##########################################
  # private function for function new_game #
  ##########################################
  # game start, initintal the state
  defp initState(inputWord) do
    %State{
      word: inputWord,
      word_to_list: String.codepoints(inputWord),
      letters: List.duplicate("_", String.length(inputWord))
    }
  end


  ##################################
  # private function for make_move #
  ##################################
  # check if already won before this guess
  defp handle_answer(%State{game_state: :won} = game, _guess, _ifused, _ifgood) do
    game
  end


  # check if already lost before this guess
  defp handle_answer(%State{game_state: :lost} = game, _guess, _ifused, _ifgood) do
    game
  end


  # execute if guess is in used
  defp handle_answer(%State{} = game, guess, true, _ifgood) do
    %State{game | game_state = :already_used}
  end

  # execute if guess is not good
  defp handle_answer(%State{} = game, guess, _ifused, false) do
    %State{game | game_state: :bad_guess,
                  turns_left: turns_left - 1,
                  used: (game.used ++ [guess])|>Enum.sort
    }
    |>check_end()
  end


  # execute if it is a good guess
  defp handle_answer(%State{} = game, guess, _ifused, _ifgood) do
    %State{game | game_state: :good_guess,
                  used: (game.used ++ [guess])|>Enum.sort
                  letters: update_letters(game.letters, game.word_to_list, guess)
    }
    |>check_end()
  end



  ########################
  # more helper function #
  ########################

  # check if lost after bad guess
  defp check_end(%State{turns_left: 0} = game) do
    %State{game | game_state: :lost,
                  letters: game.word_to_list
    }
  end

  # check if won already after right guess
  defp check_end(%State{letters = word_to_list} = game) do
    %State{game | game_state: win}
  end

  # no win, no end, nothing need to change
  defp check_end(%State{} = game) do
    game
  end


  # update letters with good guess
  defp update_letters(letters, list, guess) do

  end



end
