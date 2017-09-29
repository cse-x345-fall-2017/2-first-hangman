defmodule Hangman.Impl do
  def new_game() do
    %Hangman.Game{%Hangman.Game{} | letters: Dictionary.random_word |> String.codepoints}
  end

  def tally(game = %Hangman.Game{}) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: get_tally_letters(game),
      used: game.used,
      last_guess: game.last_guess
    }
  end

  def make_move(game = %Hangman.Game{}, guess) do
    updated_game = %Hangman.Game{game | last_guess: guess} |>
                   check_guess() |>
                   update_used_letters() |>
                   update_turns_left |>
                   check_game_over

    
    #game = %Hangman.Game{game | last_guessed: guess, turns_left: game.turns_left - 1}
    {updated_game, tally(updated_game)}
  end

  def get_tally_letters(%Hangman.Game{game_state: :lost, letters: letters}) do
    letters
  end
  
  def get_tally_letters(%Hangman.Game{letters: letters, used: used}) do
    letters
    |> hide_chars(used)
  end

  def hide_chars([head| tail], used_letters) do
    if (Enum.member?(used_letters, head)) do
        [head, hide_chars(tail, used_letters)]
    else
        ["_", hide_chars(tail, used_letters)]
    end
  end

  def hide_chars([], _used_letters) do
    []
  end

  def check_guess(game = %Hangman.Game{used: used, letters: letters, last_guess: guess}) do
    cond do
      guess in used ->
        %Hangman.Game{game | game_state: :already_guessed}
      guess in letters ->
        %Hangman.Game{game | game_state: :good_guess}
      guess not in letters ->
        %Hangman.Game{game | game_state: :bad_guess}
    end
  end
  
  def update_used_letters(game = %Hangman.Game{used: used, last_guess: guess}) do
    used = MapSet.new(used) |> MapSet.put(guess) |> MapSet.to_list
    %Hangman.Game{game | used: used}
  end

  def update_turns_left(game = %Hangman.Game{game_state: :bad_guess, turns_left: turns_left}) do
    %Hangman.Game{game | turns_left: turns_left - 1}
  end

  def update_turns_left(game = %Hangman.Game{}) do
    game
  end
  
  def check_game_over(game = %Hangman.Game{game_state: :bad_guess, turns_left: 0}) do
    %Hangman.Game{game| game_state: :lost}
  end

  def check_game_over(game = %Hangman.Game{game_state: :good_guess, used: used, letters: letters}) do
        diff_len = letters
                   |> MapSet.new
                   |> MapSet.difference(MapSet.new(used))
                   |> MapSet.size
        case diff_len do
          0 -> %Hangman.Game{game | game_state: :won}
          _ -> game
        end
  end

  def check_game_over(game = %Hangman.Game{}) do
    game
  end
end