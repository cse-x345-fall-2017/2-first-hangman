defmodule Hangman.Move do

  # try to specify that guess should a String with length of one
  # but guard clauses forbid invoking my functions or even String.length
  def make_move(game = %Hangman.Struct{}, guess) when is_bitstring(guess) do
    #once a movement is made
    #fisr update used and last_guess
    last_guess = guess
    new_used   =
      case guess in game.used do
	true   -> game.used
	false  -> game.used ++ List.wrap(guess)
      end
    new_game   = %Hangman.Struct{ game | used: new_used, last_guess: last_guess}
    final_game = is_in(guess in new_game.word, new_game, guess)
    { final_game, Hangman.Tally.tally(final_game) }
  end

  def make_move(_,_) do
    # when fed invalid data
    raise RuntimeError, message: "A Hangman.Struct and a letter are required here!"
    { :error, "A Hangman.Struct and a letter are required here!" }
  end
  
  def is_in(true, game, guess) do
    #good_guess -> update game_state, word and letters, and check is_won
    index       = Enum.find_index(game.word, fn(x) -> x == guess end)
    new_word    = List.replace_at(game.word, index, "_")
    new_letters = List.replace_at(game.letters, index, guess)
    new_game    = %Hangman.Struct{ game | game_state: :good_guess, word: new_word, letters: new_letters }
    is_won("_" in new_game.letters, new_game)
  end

  def is_in(false, game, _guess) do
    #bad_guess -> update game_state and turns_left, and check is_lost
    new_game = %Hangman.Struct{ game | game_state: :bad_guess, turns_left: game.turns_left - 1 }
    is_lost(new_game.turns_left == 0, new_game)
  end
  
  def is_won(false, game) do
    #finally examine is_won to update final game_state
    %Hangman.Struct{ game | game_state: :won}
  end

  def is_won(true, game),   do: game

  def is_lost(true, game) do
    #indicate the whole word when lost
    word = Hangman.Tool.combine(game.word, game.letters, length(game.word))
    %Hangman.Struct{ game | game_state: :lost, letters: word}
  end

  def is_lost(false, game), do: game

end
