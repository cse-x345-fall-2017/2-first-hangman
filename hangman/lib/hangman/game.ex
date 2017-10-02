defmodule Hangman.Game do

  defmodule State do

    defstruct(
      game_state:    :initializing,
      turns_left:    7,
      answer:        "",
      letters:       [],
      used:          [],
      last_guess:    ""
    )

  end

  def new_game() do
    word = Dictionary.random_word()
    %State{answer: word, letters: fill_in_word(word, [])}
  end

  def tally(game) do
    %{
      game_state:     game.game_state,
      turns_left:     game.turns_left,
      letters:        game.letters,
      used:           game.used,
      last_guess:     game.last_guess
    }
  end

  def make_move(game, guess) do

    handle_guess(game, guess, game.last_guess,
      first_matching_index(game.answer, guess),
      first_blank_index(fill_in_word(game.answer, game.used ++ [ guess ])),
      game.turns_left)

  end

 # Player loses
  defp handle_guess(game, guess, _, nil, _, 1) do
    new_state =
      %State{game | game_state:     :lost,
                    turns_left:     0,
                    letters:        String.codepoints(game.answer),
                    used:           game.used ++ [ guess ],
                    last_guess:     guess
      }

    {new_state, tally(new_state)}

  end

  # Player's guess is a repeat
  defp handle_guess(game, guess, guess, _, _, _) do
    new_state =
      %State{game | game_state:     :already_used,
                    turns_left:     game.turns_left - 1,
                    letters:        fill_in_word(game.answer,
                                      game.used ++ [ guess ]),
                    used:           game.used ++ [ guess ],
                    last_guess:     guess
      }

    {new_state, tally(new_state)}

  end

  # Player guesses incorrectly
  defp handle_guess(game, guess, _, nil, _, _) do
    new_state =
      %State{game | game_state:     :bad_guess,
                    turns_left:     game.turns_left - 1,
                    letters:        fill_in_word(game.answer,
                                      game.used ++ [ guess ]),
                    used:           game.used ++ [ guess ],
                    last_guess:     guess
      }

    {new_state, tally(new_state)}

  end

  # Player wins
  defp handle_guess(game, guess, _, _, nil, _) do
    new_state =
      %State{game | game_state:     :won,
                    letters:        String.codepoints(game.answer),
                    used:           game.used ++ [ guess ],
                    last_guess:     guess
      }

    {new_state, tally(new_state)}

  end

  # Player guesses correctly
  defp handle_guess(game, guess, _, _, _, _) do
    new_state =
      %State{game | game_state:     :good_guess,
                    letters:        fill_in_word(game.answer,
                                      game.used ++ [ guess ]),
                    used:           game.used ++ [ guess ],
                    last_guess:     guess
      }

    {new_state, tally(new_state)}

  end

  defp first_matching_index(word, letter) do
    Enum.find_index(String.codepoints(word), fn(a) -> a == letter end)
  end

  def fill_in_word(word, guess_list) do
    word
    |> String.codepoints
    |> Enum.map(fn(word_letter) ->
         Enum.find(guess_list, "_", fn(a) ->
           a == word_letter end)
      end)
  end

  defp first_blank_index(list) do
    Enum.find_index(list, fn(a) -> a == "_" end)
  end

end
