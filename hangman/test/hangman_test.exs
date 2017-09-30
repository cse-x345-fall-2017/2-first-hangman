defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "creates new game" do
    %{game_state: game_state, letters: letters} = Hangman.new_game()
    assert game_state == :initializing
    assert length(letters)
  end

  @game %Hangman.Game{letters: String.codepoints("testword"), last_guess: "z"}
  test "check bad guess" do
    %Hangman.Game{game_state: game_state} = Hangman.Impl.check_guess(@game)
    assert game_state == :bad_guess
  end

  @game %Hangman.Game{@game| last_guess: "e"}
  test "check good guess" do 
    %Hangman.Game{game_state: game_state} = Hangman.Impl.check_guess(@game)
    assert game_state == :good_guess
  end

  @game %Hangman.Game{@game| used: ["e"]}
  test "check already used guess" do 
    %Hangman.Game{game_state: game_state} = Hangman.Impl.check_guess(@game)
    assert game_state == :already_guessed
  end

  @game %Hangman.Game{@game| used: ["a", "e", "i", "o", "u"]}
  test "get_tally_letters correctly hides not guessed letters" do
    letters = Hangman.Impl.get_tally_letters(@game)
    assert Enum.join(letters) == Enum.join(["_", "e", "_", "_", "_", "o", "_", "_"])
  end
  
  @game %Hangman.Game{@game| game_state: :lost}
  test "get_tally_letters correctly unhides letters on lost game" do
    letters = Hangman.Impl.get_tally_letters(@game)
    assert Enum.join(letters) == "testword"
  end

  @game %Hangman.Game{last_guess: "e", used: ["b", "c", "q"]}
  test "update_used_letters adds guess to used letter list in alphabetical order" do
    %Hangman.Game{used: used} = Hangman.Impl.update_used_letters(@game)
    assert Enum.join(used) == "bceq"
  end

  @game %Hangman.Game{last_guess: "e", used: ["b", "c", "e", "q"]}
  test "update_used_letters doesn't add duplicate guesses to used letter list" do
    %Hangman.Game{used: used} = Hangman.Impl.update_used_letters(@game)
    assert Enum.join(used) == "bceq"
  end

  #check game over
end
