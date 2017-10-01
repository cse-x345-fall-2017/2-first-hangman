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

    def tally(game), do: Map.delete(game,:word)

#####################################################################

    def make_move(game, guess) do

        guess_ok?(Regex.match?(~r/[a-z]/, guess))

        %{word: w, letters: l, used: u, turns_left: tl} = game

        {game_state, tl, l, u} = 
        guess_attempt(
            Enum.any?(w,fn(x) -> x == guess end),
            Enum.any?(u,fn(x) -> x == guess end),
            w,
            l,
            tl,
            tl == 1,
            u,
            guess
        ) 

        {
            %{ 
                game_state: game_state,
                turns_left: tl,
                word: w,
                letters: l,
                used: u,
                last_guess: guess
            },
            %{
                game_state: game_state,
                turns_left: tl,
                letters: l,
                used: u,
                last_guess: guess
            }
        }
    end

    defp guess_ok?(false), do: raise "Please enter an English alphabet character"
    defp guess_ok?(_),     do: :ok

    defp guess_attempt(_, true, _, l, tl, _, u, _),          do: {:already_used, tl, l, u}

    defp guess_attempt(false, _, _, l, tl, false, u, guess), do: {:bad_guess, tl-1, l, format_used(u,guess)}
    defp guess_attempt(false, _, w, _, tl, true, u, guess),  do: {:lost, tl-1, w, format_used(u,guess)}

    defp guess_attempt(true, false, w, l, tl, _, u, guess),  do: insert_guess(w, w, l, tl, guess, true, u)

    defp win_check(true, w, _, tl, u),                       do: {:won, tl, w, u}
    defp win_check(false, _, l, tl, u),                      do: {:good_guess, tl, l, u}

    #:good_guess passed, function below will always insert into
    #letters field at least once then check for response

    defp insert_guess(_,w, l, tl, guess, nil, u),   do: win_check(w == l, w, l, tl, format_used(u,guess))
    defp insert_guess(w_ref, w, l, tl, guess, _, u) do 
    
        index = Enum.find_index(w_ref, fn(x) -> x == guess end)

        l = List.replace_at(l, index, guess)
        w_ref = List.replace_at(w_ref,index, "!")

        insert_guess(w_ref, w, l, tl, guess, Enum.find_index(w_ref, fn(x) -> x == guess end), u)
    end
    

    defp format_used(used, guess) do
        (used ++ [guess])
        |> Enum.into(MapSet.new)
        |> MapSet.to_list()

    end


end