defmodule Hangman.Game do

    defstruct(
        turns_left: 7, 
        game_state: :initializing,
        word: [],
        letters: [],
        used: [],
        last_guess: ""
    )

#####################################################################

    def new_game() do
        new_word = Dictionary.random_word()
        |> String.trim("\r")
        |> String.graphemes()

        %Hangman.Game{
            word: new_word, 
            letters: List.duplicate("_",length(new_word))
        }
    end

#####################################################################

    def tally(game) do 
        %{game_state: status, turns_left: left, letters: l,
            used: u, last_guess: g} = game
    end

#####################################################################

    def make_move(game, guess) do

        guess_ok?(Regex.match?(~r/[a-z]/, guess))

        %{word: w, letters: l, used: u, turns_left: tl} = game

        {game_state, new_l, u} = 
        guess_attempt(
            Enum.any?(w,fn(x) -> x == guess end),
            Enum.any?(u,fn(x) -> x == guess end),
            w,
            l,
            u,
            guess
        ) 

        {game_state, tl, new_l} = 
        game_check(
            game_state,
            w,
            new_l,
            tl <= 1,
            tl,
            w == new_l
        ) 

        {
            %{ 
                game_state: game_state,
                turns_left: tl,
                word: w,
                letters: new_l,
                used: u,
                last_guess: guess
            },
            %{
                game_state: game_state,
                turns_left: tl,
                letters: new_l,
                used: u,
                last_guess: guess
            }
        }
    end

    defp guess_ok?(false), do: raise "Please enter an English alphabet character"
    defp guess_ok?(_), do: :ok

    defp guess_attempt(_, true, _, l, u, _),         do: {:already_used, l, u}
    defp guess_attempt(false, _, _, l, u, guess),    do: {:bad_guess, l, format_used(u,guess)}
    defp guess_attempt(true, false, w, l, u, guess), do: insert_guess(w, l, guess, true, u)

    #:good_guess passed, function below will always insert into
    #letters field at least once

    defp insert_guess(_, l, guess, nil, u),          do: {:good_guess, l, format_used(u,guess)}
    defp insert_guess(w, l, guess, _, u) do 
    
        index = Enum.find_index(w, fn(x) -> x == guess end)

        l = List.replace_at(l, index, guess)
        w = List.replace_at(w,index, "!")

        insert_guess(w, l, guess, Enum.find_index(w, fn(x) -> x == guess end), u)
    end

    #Changes state of game based on the guess result

    defp game_check(:already_used, _, l, _, tl, _),   do: {:already_used, tl, l}

    defp game_check(:bad_guess, _, l, false, tl, _),  do: {:bad_guess, tl-1, l}
    defp game_check(:bad_guess, w, _, true, tl, _),   do: {:lost, tl-1, w}

    defp game_check(:good_guess, _, l, _, tl, false), do: {:good_guess, tl, l}
    defp game_check(:good_guess, w, _, _, tl, true),  do: {:won, tl, w}
    

    defp format_used(used, guess) do
        (used ++ [guess])
        |> Enum.into(MapSet.new)
        |> MapSet.to_list()

    end


end