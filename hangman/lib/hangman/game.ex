defmodule Hangman.Game do
    defstruct(
        turns: 7,
        game_state: :initializing,
        used: %MapSet{},
        word: [],
        last_guess: "",
    )

  def new_game() do
    word = String.codepoints( Dictionary.random_word() )
    word = Enum.drop word, -1
    %Hangman.Game{ word: word }
  end

  def tally(game = %Hangman.Game{}) do
    letters = word_mask(game.word,game.used)
    %{letters: letters,
     turns_left: game.turns,
     game_state: game.game_state,
     used: Enum.sort( MapSet.to_list(game.used) ),
     last_guess: game.last_guess}
  end

  def make_move(game = %Hangman.Game{}, guess) do
    in_used = MapSet.member?(game.used, guess)
    used = MapSet.put( game.used, guess )
    in_word = Enum.member?( game.word, guess )
    turns = turnDecrement( in_word || in_used, game.turns )
    state = guess_type( in_word )
    state = lost(state, turns)
    mask = word_mask(game.word,used)
    game_won = won(mask,game.word)
    state = won_atom(state,game_won)
    state = used(in_used,state)
    next_game = %Hangman.Game{game | used: used, turns: turns,
    last_guess: guess,
    game_state: state}
    tally = tally(next_game)
    {next_game, tally}
  end

  def set_check(set,letter) do
    set_char(MapSet.member?(set,letter),letter)
  end

  def word_mask(word,used) do
    fun = fn(x) -> set_check(used, x) end
    word = Enum.map(word, fun)
    word
  end

  def used(true,state) do :already_used end
  def used(false,state) do state end

  def lost(:bad_guess, 0) do :lost end
  def lost(:good_guess, _turns) do :good_guess end
  def lost(:bad_guess, _turns) do :bad_guess end

  def won_atom(:good_guess, :won) do :won end
  def won_atom(state, :not_won) do state end
  
  def won(word,word) do :won end
  def won(_mask,_word) do :not_won end

  def set_char(true,b) do b end
  def set_char(false,_b) do "_" end

  def turnDecrement(true,turns) do turns end
  def turnDecrement(false,turns) do turns - 1 end

  def guess_type(true) do :good_guess end
  def guess_type(false) do :bad_guess end

end
