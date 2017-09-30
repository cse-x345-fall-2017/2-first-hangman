defmodule Hangman.Game do

    def new_game() do
        initialize_game( retrieve_word() )        
    end

    def new_game( word) do
        initialize_game( word )
    end

    def tally( game ) do
        retrieve_tally( game )
    end

    def make_move( game, guess ) do
        process_guess( game, guess )
    end

    defp initialize_game( word ) do
        %GameState{ letters:      Enum.map( word |> String.split("", trim: true), fn(_x) -> "_" end ),
                    hangman_word: MapSet.put(MapSet.new, word) }
    end

    defp retrieve_tally( %GameState{} = game ) do
        %{ game_state: game.game_state,
           turns_left: game.turns_left,
           letters:    game.letters,
           used:       game.used }    
    end

    defp retrieve_word() do
        Dictionary.WordList.random_word()
    end

    defp process_guess( %GameState{} = game, guess ) do
        #Is this a good guess?

        # Update turn using | move + 1
        #{ game, retrieve_tally(game) }
    end

    defp update_letters( %GameState{} = game, letter ) do

    end

    defp update_used(%GameState{} = game, letter ) do
        %GameState{ used: MapSet.put( game.used, letter ) }
    end

end
