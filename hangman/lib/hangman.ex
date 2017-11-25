defmodule Hangman do
  @moduledoc """
  Struct to hold intial structure of the hangman game
  """
 defstruct game_state: "initializing", letters: [], used: [], turns_left: 7, last_guess: []

 def new_game() do
   random_word =  Dictionary.random_word()
  |> String.codepoints
  |> Enum.sort

  new_status = %Hangman{}
  new_map = Map.put( new_status, :word_to_spell, random_word)
  new_map
   end


   def make_move(game, guess) do
    game = %Hangman{}
    if String.length(guess) > 1 do
    IO.puts "Please enter single letter each time, you spelling entry was rejected"
    end

    #word = "rword"
    #random_word = Enum.sort(String.graphemes word)
    random_word =  Dictionary.random_word()

    spelled_letters = Enum.sort(game.letters)
    used_letters = game.used
    turns_left = game.turns_left
    last_guessed_letter = game.last_guess
    current_status = game.game_state

    append = fn list, item ->
      list = Enum.reverse(list)
      list = [item|list]
      Enum.reverse(list)
      end

    is_good_guess = String.contains? random_word, guess

    is_letter_already_used = String.contains? List.to_string(used_letters), guess

    is_won = random_word == spelled_letters


    if is_good_guess and turns_left > 0 do

    add_letter = append.(spelled_letters, guess)

    add_used = append.(used_letters, guess)


    new_map = %{game |letters: add_letter , game_state: "Good Guess", last_guess: guess, used: add_used}

    else

    new_map = %{game |letters: "_" , game_state: "bad_guess", last_guess: guess}

    end

    if is_letter_already_used do

    new_map = %{game | game_state: "already_used", last_guess: guess}

    end

   if is_won  do
    new_map = %{game | game_state: "won", last_guess: guess}
    end

    random_word_letter_count = Kernel.inspect(spelled_letters)
    String.length(random_word_letter_count)
    spelled_word_count = Kernel.inspect(random_word)
    String.length(spelled_word_count)

      if random_word_letter_count === spelled_word_count and !is_won do
      new_map = %{game | game_state: "Lost", last_guess: guess, turns_left: turns_left - 1}
      end

      if turns_left == 0 and !is_won do
         new_map = %{game | game_state: "Lost"}
      end
       {:ok, new_map}
    end

    def tally(game) do
      game = make_move({}, "")
      game
      end

 end
