defmodule Hangman do
  @moduledoc """
  Documentation for Hangman.
  """

  @doc "Returns a struct representing
  a new game for junit to mock the state"

  def new_game do
    Game.newGame
  end

  def new_game( word ) do
    Game.newGame( word )
  end

  @doc "Returns the tally for the given game"
  def tally( game ) do
    Game.game_tally( game )
  end


  @doc "returns a tuple containing the updated game state and a tally"
  def make_move( game, guess ) do
    Game.make_move( game, guess )
  end

end
