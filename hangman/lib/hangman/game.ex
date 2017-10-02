defmodule Hangman.Game do

  defstruct game_state: :initializing,   # :won | :lost | :already_used | :good_guess | :bad_guess | :initializing
            turns_left: 7,               # the number of turns left (game starts with 7)
            letters: [],                 # a list of single character strings. If a letter in a particular
                                         # position has been guessed, that letter will appear in `letters`. 
                                         # Otherwise, it will be shown as an underscore
            used: [],                    # A sorted list of the letters already guessed
            last_guess: "",              # the last letter guessed by the player
            word: ""                     # the secret word attempting to be guessed

  def new_game() do
    word = Dictionary.random_word
    %Hangman.Game{
      word: word,
      letters: get_underscore_list(word)
    }
  end

  def tally(game) do
    game
    |> Map.from_struct
    |> Map.delete(:word)
  end

  def make_move(state = %{word: word, used: used, letters: letters}, guess) do
    game = state 
    |> Map.put(:last_guess, guess)

    letter_in_word = word |> String.contains?(guess)
    letter_is_used = guess in used
    letters_unguessed = "_" in letters
    valid_letter = String.match?(guess, ~r/^[a-z]$/)

    do_guess(game, letter_in_word, letter_is_used, letters_unguessed, valid_letter)
  end

  defp get_underscore_list(word) do
    List.duplicate("_", String.length(word))
  end

  defp get_letter_representation(letter, true) do
    letter
  end
  
  defp get_letter_representation(_, false) do
    "_"
  end

  defp set_game_state(state, new_game_state) do
    state
    |> Map.put(:game_state, new_game_state)
  end

  defp add_letter_to_used(state = %{used: used, last_guess: last_guess}) do
    state
    |> Map.put(:used, used ++ [last_guess])
  end

  defp decrement_turns(state = %{turns_left: turns_left}) do
    state
    |> Map.put(:turns_left, turns_left-1)
  end

  defp do_guess(_, _, _, _, false) do
    raise ArgumentError, message: "Invalid letter, must be a-z"
  end

  # Letter already used
  defp do_guess(state, _, true, _, _) do
    game = state 
    |> set_game_state(:already_used)

    { game, tally(game) }
  end

  # Letter is in word and not used, game not over
  defp do_guess(state, true, false, true, _) do
    game = state 
    |> set_game_state(:good_guess)
    |> add_letter_to_used
    |> add_decoded_letters_list

    { game, tally(game) }
  end

  # Last guess and letter not in word -> game over
  defp do_guess(state = %{turns_left: 1}, false, _, _, _) do
    game = state 
    |> set_game_state(:lost)
    |> Map.put(:turns_left, 0)

    { game, tally(game) }
  end

  # Letter is not in word
  defp do_guess(state = %{used: used, turns_left: turns_left, last_guess: last_guess}, false, _, _, _) do
    game = state 
    |> set_game_state(:bad_guess)
    |> decrement_turns
    |> add_letter_to_used

    { game, tally(game) }
  end

  # Game over, all letters in word guessed
  defp do_guess(state, _, _, false, _) do
    game = state 
    |> set_game_state(:won)

    { game, tally(game) }
  end

  defp add_decoded_letters_list(state = %{word: word}) do
    new_letters = word 
    |> String.codepoints 
    |> Enum.map(&(get_letter_representation(&1, &1 in state.used)))
    
    state
    |> Map.put(:letters, new_letters)
    |> check_victory("_" in new_letters)
  end

  defp check_victory(state, false) do
    state
    |> set_game_state(:won)
  end

  defp check_victory(state, true) do
    state
  end
    
end