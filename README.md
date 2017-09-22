Your mission is to write an Elixir project named `hangman` that
implements the logic of our Hangman game.

It will have a simple API:

~~~ elixir
Hangman.new_game()                # returns a struct representing a new game
  
Hangman.tally(game)               # returns the tally for the given game
  
Hangman.make_move(game, guess)    # returns a tuple containing the updated game
                                  # state and a tally
~~~

The `tally` is a map containing the following fields:

~~~ elixir
game_state:    # :won | :lost | :already_used | :good_guess | :bad_guess | :initializing
turns_left:    # the number of turns left (game starts with 7)
letters:       # a list of single character strings. If a letter in a particular
               # position has been guessed, that letter will appear in `letters`. 
               # Otherwise, it will be shown as an underscore
used:          # A sorted list of the letters already guessed
last_guess:    # the last letter guessed by the player
~~~ 

This tally is used by projects we'll be writing later. It allows them to display the
state of the game.

Here's a sample iex session that shows the Hangman module being exercised.

~~~ elixir
iex> game = Hangman.new_game()
# ...

iex> Hangman.tally(game)
%{ game_state: :initializing, turns_left: 7, letters: ["_", "_", "_"], used: [] }

iex> { game, tally } = Hangman.make_move(game, "a")
# ...

iex> tally
%{ game_state: :good_guess, turns_left: 7, letters: ["_", "a", "_"], used: ["a"] }

iex> { game, tally } = Hangman.make_move(game, "b")
# ...

iex> tally
%{ game_state: :bad_guess, turns_left: 6, letters: ["_", "a", "_"], used: ["a", "b"] }

iex> { game, tally } = Hangman.make_move(game, "c")
# ...

iex> tally
%{ game_state: :good_guess, turns_left: 6, letters: ["c", "a", "_"], used: ["a", "b", "c"] }

iex> { game, tally } = Hangman.make_move(game, "t")
# ...

iex> tally
%{ game_state: :won, turns_left: 6, letters: ["c", "a", "t"], used: ["a", "b", "c", "t"] }
~~~



## Suggested Steps

* The directory containing this README is where you'll create the
  hangman project. You'll use `mix new` to do this. There's already a
  dictionary project in this directory, along with a human interface
  to the code you're about to write, so after you create the hangman 
  project a directory listing will show three subdirectories:
  
  ~~~
  dictionary/      hangman/      /human_player
  ~~~
  
* Move into the hangman directory and run `mix test` to make sure all
  is OK.
  
* Now add the dictionary project as a dependency to hangman's
  `mix.exs`.
  
* Make sure you got this right by running `iex -S mix` and then
  typing `Dictionary.random_word()`. You should see iex display a
  word. 
  
* You're going to write the API in `lib/hangman.ex`. It is going to
  delegate the three API functions to the module `Hangman.Game` (in
  `lib/hangman/game`). This is where you'll be implementing the game.
  
## If I Were You...

* I'd start by defining a struct to hold the internal game state.
  I'd put just a couple of fields into it for now (maybe the number of
  turns left and the game status (`:initializing`). 
  
* Then I'd write `new_game()` which returns this struct, and fire up
  `iex -S mix` to try it.

* I'd think about how I want to represent the word to be guessed, and
  how to represent the letters guessed so far. I'd add these to the
  struct.
  
* Then I'd update `new_game()` to populate the word to be guessed,
  calling `Dictionary.random_word()`.
  
* I'd probably then implement the `tally()` function, which takes the
  Game structure and returns the map described above. Some fields are
  copied straight from the state to the tally, while others may need
  to be massaged a little.
  
* If the player has just won or lost, the `letters` field in the tally
  should contain the full word (no underscores).
  
* Finally it's time to implement `make_move()`. I love this kind of
  implementation because it gives me a lot of opportunities to use
  pattern matching and small helper functions. (That's a hint)
  
## Once You're Done

I've included a third project, called `human_player`. If you go into
its directory and enter the command 

~~~
$  mix run -e HumanPlayer.play
~~~

This will run the hangman code and play a game with you.
  
## Grading

This assignment will be graded out of 120 points.

| marks | for                                        |
| ----: | ------------------------------------------ |
|    70 | Does the program work and meet the API? | 
|     5 | Does it follow the structure above? | 
|    10 | Is the code divided into small functions? | 
|    10 | Does it use pattern matching where possible in preference to conditional logic? | 
|     5 | Does it raise exceptions when fed invalid data? | 
|    10 | Is the program written in an idiomatic style that uses appropriate and effective language and library features | 
|     5 | Is the code well laid out,  appropriately using indentation, blank lines, vertical alignment? | 
|     5 | Are names well chosen, descriptive, but not verbose? |

An additional 10 bonus points are available for exceptional code that
delights me.

