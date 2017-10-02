defmodule Hangman.Impl do
  # Implementation for Hangman Interface.

  import Hangman.Helper

  defmodule Tally do
    defstruct(
      game_state: :initalizing,
      turns_left: 7,
      word: "",
      letters:    [],
      used: []
    )
  end


  def new_game() do
    word = Dictionary.random_word()
    %Tally{
      letters: get_letters(word, []),
      word: word
    }
  end

  # Hide word from game_state
  def tally(game) do
    game
    |> Map.from_struct
    |> Map.delete(:word)
  end

  # If you lost just return
  def make_move(%Tally{ game_state: :lost } = state, _) do
    { state, tally(state) }
  end

  # If you already won just return
  def make_move(%Tally{ game_state: :won } = state, _) do
    { state, tally(state) }
  end

  #  Continue Playing
  def make_move(game, guess) do
    state = determine_game_state(game, guess, guess in game.used, valid_guess(guess))
    { state, tally(state) }
  end

  # Pattern match for valid guess. If not calid character throw error
  def determine_game_state(_,_,_,false) do
    raise ArgumentError, message: "invalid"
  end

  # If guess has already been used
  def determine_game_state(game, _, true, true) do
    %Tally{ game | game_state: :used }
  end

  # If both valid guess and not already used, update state
  def determine_game_state(game, guess, false, true) do
    update_state(game, guess)
  end

  def update_state(game, guess) do
    state = %Tally{ game | game_state: get_state(game.word, guess) }
    update_state(state, guess, state.game_state, game.turns_left)
  end

  def update_state(game, _, :bad_guess, 0), do: %Tally{ game | game_state: :lost }
  def update_state(game, guess, :bad_guess, _) do
    %Tally{ game | used: game.used ++ [guess] }
    |> turn
  end

  def update_state(game, guess, :good_guess, _) do
    %Tally{ game | used: game.used ++ [guess] }
    |> update_letters
    |> determine_win
  end

  def update_letters(game) do
    new_letters = get_letters(game.word, game.used)
    %Tally{ game | letters: new_letters }
  end

  def determine_win(game), do: determine_win(game, "_" in game.letters)
  def determine_win(game, false), do: %Tally{ game | game_state: :won }
  def determine_win(game, true), do: game

  def get_state(true), do: :good_guess
  def get_state(false), do: :bad_guess
  def get_state(word, guess) do
    String.contains?(word, guess)
    |> get_state
  end

  def valid_guess(guess) do
    guess
    |> String.match?(~r/^[A-Za-z]$/)
  end

  def turn(game), do: %Tally{ game | turns_left: game.turns_left - 1}



end
