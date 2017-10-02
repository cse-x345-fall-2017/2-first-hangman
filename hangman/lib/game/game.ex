defmodule Hangman.Game do

#Public Functions

    def new_game() do
        initialize_game( retrieve_word() )        
    end

    def new_game(word) do
        initialize_game( word |> String.split("", trim: true) )
    end

    def tally( game ) do
        retrieve_tally( game )
    end

    def make_move( game, guess ) do
        process_guess( game, guess )
    end

#Private Functions

    defp initialize_game( word ) do
        %GameState{ letters:      Enum.map( word, fn _ -> "_" end), 
                    hangman_word: word }
    end

    defp retrieve_tally( %GameState{} = game ) do
        %{ game_state: game.game_state,
           turns_left: game.turns_left,
           letters:    game.letters,
           used:       game.used,
           last_guess: game.last_guess }    
    end

    defp retrieve_word() do
        Dictionary.WordList.random_word() |> String.split( "", trim: true ) 
    end

    defp process_guess( game, guess ) do
        game = game |> guess( Enum.member?(game.hangman_word, guess), 
                              Enum.member?(game.used, guess), 
                              guess )

        game = game |> game_over?( Enum.member?(game.letters, "_") )

        { game, game |> retrieve_tally }
    end

    defp guess( game, true, false, guess ) do
        %GameState{ game | game_state: :good_guess,
                           letters:     replace_letters( game.hangman_word,game.letters, guess),
                           used:        game.used ++ [ guess ] |> Enum.sort,
                           last_guess:  guess }
    end

    defp guess( game, false, false, guess ) do
        %GameState{ game | game_state: :bad_guess,
                           turns_left:  game.turns_left - 1,
                           used:        game.used ++ [ guess ] |> Enum.sort,
                           last_guess:  guess }
    end

    defp guess( game, _, true, _ ) do
        %GameState{ game | game_state: :already_used }
    end

    defp replace_letters( [], [], _guess ) do [] end
    
    defp replace_letters( [ guess | tail1 ], [ _head2 | tail2 ], guess ) do
        [ guess | replace_letters( tail1, tail2, guess) ]
    end

    defp replace_letters( [ _head1 | tail1 ], [ letter | tail2 ], guess ) do
        [ letter | replace_letters( tail1, tail2, guess ) ]
    end

    defp game_over?( game = %GameState{ game_state: :good_guess }, false ) do
        %GameState{ game_state: :won, letters: game.hangman_word }        
    end

    defp game_over?( game = %GameState{ game_state: :bad_guess, turns_left: 0 }, true ) do
        %GameState{ game_state: :lost, letters: game.hangman_word }
    end

    defp game_over?( game = %GameState{}, _ ) do
        game
    end
end
