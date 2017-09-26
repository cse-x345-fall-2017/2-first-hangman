defmodule Hangman.Game do

    #tally use mapset
    #set state to initializing 
    #set turns_left to 7
    #generate random_word
    #create list of underscores that is the lenght of the word
    #default used to []
    #use Map.put to update state

    def new_game() do
        initialize_hangman_game()
    end

    def tally( game ) do
        
    end

    def make_move( game, guess ) do
    end

    defp retrieve_word() do
        Dictionary.WordList.random_word()
            |> String.split("", trim: true)
    end

    defp initialize_hangman_game() do
         retrieve_word() 
    end

    defp populate_letters( word ) do
        
    end

end
