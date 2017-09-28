defmodule Hangman.GameTest do
  use ExUnit.Case

  test "new game initiliazed" do
    assert %Hangman.Game.State{ game_state: :initializing } = Hangman.Game.new_game()
  end

  test "already used" do
    g = Hangman.Game.new_game()
    { g, _t } = Hangman.Game.make_move(g, "a")
    { %Hangman.Game.State{ game_state: :already_used }, _t } = Hangman.Game.make_move(g, "a")
  end

  test "good guess and turns remain same" do
    g = Hangman.Game.new_game()
    letter = String.at(g.word, 0)
    { %Hangman.Game.State{  game_state: :good_guess,
      turns_left: 7 }, _t } = Hangman.Game.make_move(g, letter)
  end

  test "bad guess and turns decreasing" do
    g = Hangman.Game.new_game()
    left_letters_set = g.left_letters_set
    alphabet_set = MapSet.new("abcdefghijklmnopqrstuvwxyz"
                              |> String.codepoints())
    rest_set = MapSet.difference(alphabet_set, left_letters_set)
    letter = Enum.fetch!(rest_set, 0)
    { %Hangman.Game.State{  game_state: :bad_guess,
      turns_left: 6 }, _t } = Hangman.Game.make_move(g, letter)
  end

  test "lost" do
    g = Hangman.Game.new_game()
    left_letters_set = g.left_letters_set
    alphabet_set = MapSet.new("abcdefghijklmnopqrstuvwxyz"
                              |> String.codepoints())
    rest_set = MapSet.difference(alphabet_set, left_letters_set)
    assert :lost == make_moves(g, rest_set, 0, 7)
  end

  test "won" do
    g = Hangman.Game.new_game()
    left_letters_set = g.left_letters_set
    assert :won == make_moves(g, left_letters_set, 0, MapSet.size(left_letters_set))
  end

  test "check if letters are revealed after right guess and, check if used and last_guess are updated" do
    g = Hangman.Game.new_game("test")
    { g, %{  letters: [ "_", "e", "_", "_" ],
      last_guess: "e" ,
      used: ["e"] } } = Hangman.Game.make_move(g, "e")

    { g, %{ letters: [ "_", "e", "_", "_" ],
      last_guess: "a" ,
      used: [ "a", "e" ] } } = Hangman.Game.make_move(g, "a")

    { _g, %{  letters: [ "t", "e", "_", "t" ],
      last_guess: "t",
      used: [ "a", "e", "t" ] } } = Hangman.Game.make_move(g, "t")

  end

  ################################
  # Helper functions for testing #
  ################################

  defp make_moves(g, rest_set, counter, len) when counter < len do
    letter = Enum.fetch!(rest_set, 0)
    { g, _t } = Hangman.Game.make_move(g, letter)
    make_moves(g, MapSet.delete(rest_set, letter), counter + 1, len)
  end

  defp make_moves(g, _, _, _) do
    g.game_state
  end

end
