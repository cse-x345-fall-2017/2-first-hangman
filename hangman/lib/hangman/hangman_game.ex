defmodule Hangman.Game do
  defmodule State do
    defstruct(game_state: :initializing, 
              turns_left: 7,               
              shown_letters: [],        #If user won or lost, letters list would be shown_letters list
              letters: [],
              used: [],
              word: "",
              last_guess: "" 
              )
  end

  def tally(state = %State{letters: l, shown_letters: sl}) when (l == sl) do
      %{game_state: :won, 
        turns_left: state.turns_left, 
        letters: state.shown_letters,
        used: [], 
        last_guess: state.last_guess
        }
  end

  def tally(state = %State{turns_left: tl}) when (tl == 0) do
      %{game_state: :lost, 
        turns_left: state.turns_left, 
        letters: state.shown_letters,
        used: [], 
        last_guess: ""
        }
  end

  def tally(state = %State{}) do               
      %{game_state: state.game_state, 
             turns_left: state.turns_left, 
             letters: state.letters,
             used: state.used, 
             last_guess: state.last_guess
             }
  end

  def new_game() do
      word = Dictionary.random_word()
      shown_letters = String.codepoints(word)
      letters = Enum.map(shown_letters, fn(_) -> "_" end)
      %State{shown_letters: shown_letters, letters: letters, word: word}
  end

  def make_move(current_state, try_letter) do
      current_state = %State{current_state | last_guess: try_letter}
      new_state = handle_guess(jackpot?(current_state, try_letter),
                                try_letter_used?(current_state, try_letter),
                                current_state
                                )
      {new_state, tally(new_state)}
  end    

  def handle_guess([], false, current_state) do      #When try fail and letter is not in used.
      %State{current_state | game_state: :bad_guess, 
                        turns_left: current_state.turns_left - 1,
                        used: Enum.sort(current_state.used ++ [current_state.last_guess])
                        }
  end
  
  def handle_guess(location_index, false, current_state) do    #try_letter in letters not in used.
      new_letters = visible_guessed_letters(location_index, current_state.letters, 
                                            current_state.last_guess)
      %State{current_state | game_state: :good_guess,
                        used: Enum.sort(current_state.used ++ [current_state.last_guess]),
                        letters: new_letters
                        }
  end
  
  def handle_guess(_, true, current_state) do        #try_letter used, turns_left minus one.
      %State{current_state | game_state: :already_used,
                        turns_left: current_state.turns_left - 1
                        }
  end

  def visible_guessed_letters(location_index, letters_list, try_letter) do      
      List.replace_at(letters_list, Enum.at(location_index, 0), try_letter)      
  end
  
  def jackpot?(current_state, try_letter) do         #Extract index(s) of every guessed letter. If not, returns [].
      Enum.with_index(current_state.shown_letters) 
      |> Enum.filter(fn({a, _}) -> a == try_letter end)
      |> Enum.map(fn({_, b}) -> b end)          
  end
  
  def try_letter_used?(current_state, try_letter) do
      try_letter in current_state.used
  end
end
