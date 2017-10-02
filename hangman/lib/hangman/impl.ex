defmodule Hangman.Impl do
 
  # state of game
  defmodule State do
    defstruct game_state: :initializing, turns_left: 7, letters: [], used: [], last_guess: "", word: "", word_to_list: []
  end

  # returns a struct representing a new game
  def new_game() do
    Dictionary.random_word()
    |> String.trim("/r")
    |> initState()
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
  def make_move(%State{} = game, guess) do
    game = handle_answer( game, guess, guess in game.used, guess in game.word_to_list )
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

  # execute if guess is in used
  defp handle_answer(%State{} = game, _guess, true, _ifgood) do
    %State{game | game_state: :already_used}
  end

  # execute if guess is not good
  defp handle_answer(%State{} = game, guess, _ifused, false) do
    %State{game | game_state: :bad_guess,
                  turns_left: game.turns_left - 1,
                  used: (game.used ++ [guess])|>Enum.sort
    }
    |>check_end(game.word_to_list, game.letters)
  end



  # execute if guess is good
  defp handle_answer(%State{} = game, guess, _ifused, _ifgood) do
    game = %State{game | game_state: :good_guess,
                         used: (game.used ++ [guess])|>Enum.sort,
                         letters: update_letters(game.letters, game.word_to_list, guess)
                 }
    check_end(game, game.word_to_list, game.letters)
  end







  ########################
  # more helper function #
  ########################

  # check if lost after bad guess
  defp check_end(%State{turns_left: 0} = game, _, _) do
    %State{game | game_state: :lost,
                  letters: game.word_to_list
    }
  end

  # check if win after right guess
  defp check_end(%State{} = game, w, w) do
    %State{game | game_state: :won}
  end

  # no win, no end, nothing need to change
  defp check_end(%State{} = game, _word_to_list, _letters) do
    game
  end


  # update letters with good guess
  defp update_letters(letters, list, guess) do
    Enum.find_index(list, fn(x) -> x == guess end)
    |>update_letters2(letters, list, guess)
  end
  
  defp update_letters2(nil, letters, _list, _guess) do   
    letters
  end

  defp update_letters2(i, letters, list, guess) do
    list=List.replace_at(list,i,"5")
    letters=List.replace_at(letters, i, guess)
    Enum.find_index(list, fn(x) -> x == guess end)
    |>update_letters2(letters, list, guess)
  end

end
