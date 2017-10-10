defmodule HangmanTest do
  use ExUnit.Case
  doctest Hangman

  test "greets the world" do
    assert Hangman.hello() == :world
  end

  test "returns new game" do
    state = Hangman.new_game()
    assert state.game_state == :initializing
    assert state.turns_left == 7
    assert state.used == []
    assert state.last_guess == ""

    # Are all characters blanks?
    are_blanks = fn x -> String.equivalent?(x, "_") end
    assert Enum.all?(state.letters, are_blanks) == true
    
    # Is the word non-empty?
    assert [ _head | _tail ] = state.word
  end

  test "returns proper tally" do
    game = Hangman.new_game()
    assert %{
      game_state: _,
      turns_left: _,
      used: _,
      letters: _,
      last_guess: _
    } = Hangman.tally(game)
  end

  test "make move returns game and tally" do
    # Using test word "elba"
    game = Hangman.new_game()
    game = %State{game |
    word: ["e", "l", "b", "a"],
    letters: ["_", "_", "_", "_"]
    }

    assert { game, tally } = Hangman.make_move(game, "e")
    assert %State{} = game
    assert %{
      game_state: _,
      turns_left: _,
      used: _,
      letters: _,
      last_guess: _
    } = tally
  end

  test "game status changes correctly on making move" do
    # Using test word "elba"
    game = Hangman.new_game()
    game = %State{game |
    word: ["e", "l", "b", "a"],
    letters: ["_", "_", "_", "_"]
    }

    # Good guess
    { game, tally } = Hangman.make_move(game, "e")
    assert tally.game_state == :good_guess
    # Bad guess
    { _, tally } = Hangman.make_move(game, "c")
    assert tally.game_state == :bad_guess
  end

  test "number of turns left changes correctly on making move" do
    # Using test word "elba"
    game = Hangman.new_game()
    game = %State{game | word: ["e", "l", "b", "a"]}

    turns_left = game.turns_left
    # Good guess
    { game, tally } = Hangman.make_move(game, "e")
    assert tally.turns_left == turns_left
    # Bad guess
    { _, tally } = Hangman.make_move(game, "c")
    assert tally.turns_left == turns_left - 1
  end

  test "used alphabets recorded correctly on making move" do
    # Using test word "elba"
    game = Hangman.new_game()
    game = %State{game |
    word: ["e", "l", "b", "a"],
    letters: ["_", "_", "_", "_"]
    }

    # Good guess
    { game, tally } = Hangman.make_move(game, "e")
    assert tally.used == ["e"]
    # Bad guess
    { _, tally } = Hangman.make_move(game, "c")
    assert tally.used == ["c", "e"]
  end

  test "letters guessed recorded correctly on making move" do
    # Using test word "elba"
    game = Hangman.new_game()
    game = %State{game |
    word: ["e", "l", "b", "a"],
    letters: ["_", "_", "_", "_"]
    }

    # Good guess
    { game, tally } = Hangman.make_move(game, "e")
    assert tally.letters == ["e", "_", "_", "_"]
    # Bad guess
    { _, tally } = Hangman.make_move(game, "c")
    assert tally.letters == ["e", "_", "_", "_"]
  end

  test "last guess is recorded correctly" do
    # Using test word "elba"
    game = Hangman.new_game()
    game = %State{game |
    word: ["e", "l", "b", "a"],
    letters: ["_", "_", "_", "_"]
    }

    # Good guess
    { game, _tally } = Hangman.make_move(game, "e")
    assert game.last_guess == "e"
    # Bad guess
    { game, _tally } = Hangman.make_move(game, "c")
    assert game.last_guess == "c"
  end

  test "win condition" do
    game = Hangman.new_game()
    game = %State{game | word: ["e", "l"], letters: ["_", "_"]}

    # Good guess
    { game, _tally } = Hangman.make_move(game, "l")
    # Good guess
    { game, _tally } = Hangman.make_move(game, "e")
    assert game.game_state == :won
    assert game.letters == ["el"]
  end

  test "lose condition" do
    game = Hangman.new_game()
    game = %State{game | word: ["e", "l"], letters: ["_", "_"]}
    game = %State{game | turns_left: 1}
    # Bad guess
    { game, _tally } = Hangman.make_move(game, "a")
    assert game.game_state == :lost
  end

  test "already guessed" do
    game = Hangman.new_game()
    game = %State{game | word: ["e", "l"], letters: ["_", "_"]}
    game = %State{game | used: Enum.concat(game.used, ["l"])}
    # Already guessed
    { game, _tally } = Hangman.make_move(game, "l")
    assert game.game_state == :already_guessed
  end
end
