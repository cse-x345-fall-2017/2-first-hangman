defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "creates new game" do
    %{status: status} Hangman.new_game()
    assert status == :initializing
  end
end
