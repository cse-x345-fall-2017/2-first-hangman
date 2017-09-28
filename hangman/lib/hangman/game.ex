defmodule Hangman.Game do

    defstruct(
        turns_left: 7, 
        game_state: :initializing,
        word: [],
        letters: [],
        used: MapSet.new,
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
        %{game_state: status, turns_left: left, letters: h,
            used: u, last_guess: g} = game

        %{game_state: status, turns_left: left, letters: h,
            used: u, last_guess: g}
    end

#####################################################################

    def make_move(game, guess) do

        %{word: w, letters: h, used: u, turns_left: tl} = game

        {game_state, new_h} = guess_attempt(
            Enum.any?(w,fn(x) -> x == guess end),
            Enum.any?(u,fn(x) -> x == guess end),
            w,
            h,
            guess
        )

        {game_state, tl} = game_check(
            game_state,
            tl <= 1,
            tl,
            w == new_h
        )

        {
            %{ 
                game_state: game_state,
                turns_left: tl,
                word: w,
                letters: new_h,
                used: MapSet.union([guess] |> Enum.into(MapSet.new), u),
                last_guess: guess
            },
            %{
                game_state: game_state,
                turns_left: tl,
                letters: new_h,
                used: MapSet.union([guess] |> Enum.into(MapSet.new), u),
                last_guess: guess
            }
        }
    end

    defp guess_attempt(_, true, _, h, _),         do: {:already_used, h}
    defp guess_attempt(false, _, _, h, _),        do: {:bad_guess, h}
    defp guess_attempt(true, false, w, h, guess), do: insert_guess(w,h,guess, true)

    #:good_guess passed, function below will always insert into
    #letters field at least once

    defp insert_guess(w, h, guess, _) do 
    
        index = Enum.find_index(w, fn(x) -> x == guess end)

        h = List.replace_at(h, index, guess)
        {_, w} = List.pop_at(w,index)

        insert_guess(w, h, guess, Enum.find_index(w, fn(x) -> x == guess end))
    end
    defp insert_guess(_, h, _    , nil), do: {:good_guess, h}

    defp game_check(:already_used, _, tl, _),   do: {:already_used, tl}

    defp game_check(:bad_guess, false, tl, _),  do: {:bad_guess, tl-1}
    defp game_check(:bad_guess, true, tl, _),   do: {:lost, tl-1}

    defp game_check(:good_guess, _, tl, false), do: {:good_guess, tl}
    defp game_check(:good_guess, _, tl, true),  do: {:won, tl}
    


end