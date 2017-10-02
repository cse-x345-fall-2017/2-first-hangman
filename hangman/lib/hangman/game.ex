defmodule Game do
  @moduledoc false

  defmodule State do
    defstruct game_state: :initializing, turns_left: 7, letters: [], used: [], last_guess: "", random_word: ""
  end

  @doc "Create new game with default state and random word"
  def newGame do
    %State{ random_word: Dictionary.WordList.random_word() }
  end

  @doc "Create new game state for unit test"
  def newGame( word ) do
    %State{ random_word: word }
  end

  @doc "Returns the tally for the given game"
  def game_tally( state ) do
    %{ game_state: state.game_state,
      turns_left: state.turns_left,
      letters: word_masking_for_user(state) |> word_split(),
      used: state.used,
      last_guess: state.last_guess }
  end

  @doc "returns a tuple containing the updated game state and a tally"
  def make_move( game, guess_char ) do

    guess_char = String.downcase(guess_char) |> String.trim
    game =  handle_guess_answer(
                                word_equals_userWord( game ),
                                guess_char_contains_inWord( game, guess_char ),
                                guess_char_contains_inUsedList( game, guess_char ),
                                game
                                )
    game = %{ game |  last_guess: guess_char, used: game.used ++ [guess_char] }
    game = %{ game |  letters: word_masking_for_user(game) |> word_split() }
    { game, game_tally( game )}
  end


  # Private functions
  @doc "returns a boolean guess_char containing in random_word"
  defp guess_char_contains_inWord( game, guess_char ) do
    String.contains?( game.random_word, to_string guess_char )
  end

  @doc "returns a boolean guess_char containing in used list"
  defp guess_char_contains_inUsedList( game, guess_char ) do
    guess_char in game.used
  end

  @doc "returns a boolean random_word equals user word"
  defp word_equals_userWord( game ) do
    String.equivalent?( game.random_word, to_string game.letters )
  end


  defp handle_guess_answer( true, _, _, game ) do
    %{ game | game_state: :won }
  end

  defp handle_guess_answer( false, true, true, game ) do
    %{ game | game_state: :already_used, turns_left: turns_left( game ) }
  end

  defp handle_guess_answer( false, false, true, game ) do
    %{ game | game_state: :already_used, turns_left: turns_left( game ) }
  end

  defp handle_guess_answer( false, true, false, game ) do
    %{ game | game_state: :good_guess, letters: word_masking_for_user( game )}
  end

  defp handle_guess_answer( false, false, false, game ) do
    %{ game | game_state: :bad_guess, turns_left: turns_left( game )}
  end

 # Utility methods
  @doc "split the word and conver to list"
  defp word_split( split_the_word ) do
    String.split( split_the_word, "", trim: true )
    |> Enum.to_list
  end

  @doc "mask the word using random_word and used list"
  defp word_masking_for_user( state ) do
    String.replace( state.random_word, ~r/[^#{[" " | state.used]}]/, "_" )
  end

  @doc "number of turns left out for user to play"
  defp turns_left( game ) do
    game.turns_left - 1
  end

end
