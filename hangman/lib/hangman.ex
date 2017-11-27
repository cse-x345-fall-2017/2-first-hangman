defmodule Hangman do

  defstruct game_state: "initializing", letters: ["y"], used: ["u"], turns_left: 7, last_guess: []


  def new_game() do
    random_word =  Dictionary.random_word()
   |> String.replace("\r","")
   |> String.codepoints
   |> Enum.sort

   current_state = %Hangman{}

   new_state = Map.put( current_state, :word_to_spell, random_word)
   new_state
 end

 def tally(game) do
  game = %Hangman{}
  spelled_letters = game.letters |> Enum.to_list

  used_letters = game.used |> Enum.to_list |> Enum.sort

  new_game_status = %{game |letters: spelled_letters, used: used_letters}
 new_game_status
 end


 def make_move(game, guess) do

    game = %Hangman{}
    if String.length(guess) > 1 do
    IO.puts "Please enter single letter each time, your spelling entry was rejected"
    end


    spelled_letters = Enum.sort(game.letters)
    used_letters = game.used
    turn_left = game.turns_left
    last_guessed_letter = game.last_guess
    current_status = game.game_state

    random_word =  Dictionary.random_word()
   |> String.replace("\r","")
   |> String.codepoints
   |> Enum.sort

      append = fn list, item ->
      list = Enum.reverse(list)
      list = [item|list]
      Enum.reverse(list)
      end

    is_good_guess = String.contains? random_word, guess
    is_letter_already_used = String.contains? List.to_string(used_letters), guess
    is_won = random_word == spelled_letters
    letters_spelled_count = game.letters |> Enum.count

    random_word_count = String.length(random_word)


    are_equal = letters_spelled_count == random_word_count


    if is_letter_already_used do
    IO.puts "The letter you entered has already been used. Please enter a new character to proceed"
    new_game = %{game |game_state: "bad Guess", last_guess: guess}
    new_game
    end

    if is_good_guess and spelled_letters == [] and used_letters == [] do

    end

   if is_good_guess and turn_left > 0 do

   add_letter = append.(spelled_letters, guess)

   add_used = append.(used_letters, guess)

   new_game = %{game |letters: add_letter, game_state: "Good Guess", last_guess: guess, used: add_used}

   else
   new_game = %{game |letters: "_" , game_state: "bad_guess", last_guess: guess}

   end
   if is_won do
   new_game = %{game |game_state: "Won", last_guess: guess}
   end

   if are_equal and !is_won and turn_left == 0 do
   new_game = %{game |game_state: "Lost", last_guess: guess}
   new_game
   end
   if are_equal and !is_won do
     new_game = %{game |turns_left: game.turns_left - 1}
   end

    end
 end
