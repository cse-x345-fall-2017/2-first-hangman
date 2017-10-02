defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman


  test "_initializing Game Initial state test" do
   state = Hangman.new_game()
   assert state.game_state == :initializing
  end

  test "_original turns_left -  Game Initial state test" do
    state = Hangman.new_game()
    assert state.turns_left == 7
  end

  test "_good_guess state - Game with random word cat with two moves" do
    game = Hangman.new_game("cat")
    tally1  = Hangman.tally(game)
    # 1 Move
    {game, tally1} = Hangman.make_move(game,"c")
    # 2 Move
    {game, tally1} = Hangman.make_move(game,"a")
    assert tally1.game_state == :good_guess
  end

  test "_used list - Game with random word cat with two moves status assert used list" do
    game = Hangman.new_game("cat")
    tally1  = Hangman.tally(game)
    # 1 Move
    {game, tally1} = Hangman.make_move(game,"c")
    # 2 Move
    {game, tally1} = Hangman.make_move(game,"a")
    assert tally1.used == ["c","a"]
  end


  test "_bad_guess state - Game with random word cat with two moves assert _bad_guess " do
    game = Hangman.new_game("cat")
    tally1  = Hangman.tally(game)
    # 1 Move
    {game, tally1} = Hangman.make_move(game,"c")
    # 2 Move
    {game, tally1} = Hangman.make_move(game,"p")
    assert tally1.game_state == :bad_guess
  end


  test "_bad_guessed_character - UpperCase  - Game with random word cat with two moves assert _bad_guess " do
    game = Hangman.new_game("cat")
    tally1  = Hangman.tally(game)
    # 1 Move
    {game, tally1} = Hangman.make_move(game,"c")
    # 2 Move
    {game, tally1} = Hangman.make_move(game,"A")
    assert tally1.game_state == :good_guess
  end

  test "_turns_lef - Game with random word cat with two moves and _bad_guess assert decrease turns_left" do
    game = Hangman.new_game("cat")
    tally1  = Hangman.tally(game)
    # 1 Move
    {game, tally1} = Hangman.make_move(game,"c")
    # 2 Move
    {game, tally1} = Hangman.make_move(game,"p")
    assert tally1.turns_left == 6
  end

  test "_last guessed - Game with random word cat with two moves assert last guessed" do
    game = Hangman.new_game("cat")
    tally1  = Hangman.tally(game)
    # 1 Move
    {game, tally1} = Hangman.make_move(game,"c")
    # 2 Move
    {game, tally1} = Hangman.make_move(game,"p")
    assert tally1.last_guess == "p"
  end


  test "_won - Game with random word cat assert :won state " do
    game = Hangman.new_game("cat")
    tally1  = Hangman.tally(game)
    # 1 Move
    {game, tally1} = Hangman.make_move(game,"c")
    # 2 Move
    {game, tally1} = Hangman.make_move(game,"a")
    # 3 Move
    {game, tally1} = Hangman.make_move(game,"t")
    {game, tally1} = Hangman.make_move(game,"K")
    assert tally1.game_state == :won
  end

end
