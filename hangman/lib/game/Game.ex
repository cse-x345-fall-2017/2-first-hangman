defmodule Hangman.Game do
  
  #This is the implement of Hangman.
  #Here are effects of different:
  #Game_record: a struct record game 
  #change_letters: check whether the user's input is correct. if so ,change "_" to user's input 
  #valid?: used in Enum.reduce, if char =="_", accumulation add 1, else add 0 
  #count: count numbers of "_" in a string, if the number equals 0, means won
  #update_record update game's record
  #play: used to receive and send message, like a simple server to maintain state
  #deal_empty: if stirng is empty return "cat" else return the string
  #init_game: initialize a new game with a certain word
  defmodule Game_record do
    defstruct game_state: :initializing, turns_left: 7, letters: [], used: [], last_guess: ""
  end
  
  @doc """
  check whether the user's input is correct. if so ,change "_" to user's input 
  ##Example
      iex> Hangman.Game.change_letters(["a","p","p","l","e"],["a","_","_","_","_"],"p")
      ["a","p","p","_","_"]
  """
  def change_letters([],[],_letter), do: []
  def change_letters([h|t],["_"|t1],h), do: [h|change_letters(t,t1,h)]
  def change_letters([_h|t],[h|t1],letter), do: [h|change_letters(t,t1,letter)]

  @doc """
  used in Enum.reduce, if char =="_", accumulation add 1, else add 0 
  ##Example
      iex> Hangman.Game.valid?("a",0)
      0
      iex> Hangman.Game.valid?("_",0)
      1
  """
  def valid?("_",acc), do: acc+1
  def valid?(_,acc), do: acc
  
  @doc """
  count numbers of "_" in a string, if the number equals 0, means won
  ##Example
      iex> Hangman.Game.count(["a","_","_","l","e"])
      2
      iex> Hangman.Game.count(["a","p","p","l","e"])
      0
  """
  def count(letters), do: Enum.reduce(letters,0,&valid?/2)

  @doc """
  update game's record by user's input
  if :good_guess or :already_used , truns_left unchanging
  ##Example
      iex> Hangman.Game.update_record(["a","p","p","l","e"],%Hangman.Game.Game_record{letters: ["_","_","_","_","_"]},"p")
      %Hangman.Game.Game_record{game_state: :good_guess, turns_left: 7,letters: ["_","p","p","_","_"], used: ["p"], last_guess: "p"}

      iex> Hangman.Game.update_record(["a","p","p","l","e"],%Hangman.Game.Game_record{letters: ["_","_","_","_","_"]},"x")
      %Hangman.Game.Game_record{game_state: :bad_guess, turns_left: 6,letters: ["_","_","_","_","_"], used: ["x"], last_guess: "x"}
  """
  def update_record(word,%Hangman.Game.Game_record{}=record,letter) do
    cond do 
      record.game_state == :won -> IO.puts "move is invalid after won"; record
      record.game_state == :lost -> IO.puts "move is invalid after lost"; record
      true ->
      letters = record.letters
      already_used = letter in record.used
      record = %{record| letters: change_letters(word,record.letters,letter),
		         last_guess: letter,
		         used: [letter|record.used] |> Enum.sort
		}
      ret = count(record.letters)
      bef = count(letters)
      cond do
        ret==0 -> %{record| game_state: :won}
        record.turns_left==1 -> %{record| game_state: :lost,
					          turns_left: record.turns_left-1,
					          letters: word};
        ret < bef -> %{record| game_state: :good_guess} 
        already_used ->  %{record| game_state: :already_used}
        true -> %{record| game_state: :bad_guess,
		            turns_left: record.turns_left-1 }
      end
    end
  end

  # "used to receive and send message, like a simple server to maintain state"  
  def play(word, record) do
    receive do
      {sender,:move,letter} ->
	record=update_record(word,record,letter)
	send sender, {self(),record |>Map.from_struct}
	play(word,record)
      {sender, :get_information} ->
	send sender, record |> Map.from_struct
	play(word,record)
    end
  end

  def receive_msg() do
    receive do
      msg ->msg
    end
  end

  @doc """
  if string is empty return "cat", else return the string
  ##Example
     iex> Hangman.Game.deal_empty([])
     "cat"
     iex> Hangman.Game.deal_empty("dog")
     "dog"
     iex> Hangman.Game.deal_empty("swan")
     "swan"

  """
  def deal_empty([]), do: "cat"
  def deal_empty(str),do: str

  # initialize a new game with a certain word
  def init_game(word) do
    word =
      word|>
      String.codepoints|>
      Enum.filter(&(&1!="\r"))|> #avoid "\r"
      deal_empty   #if word is empty ,return "cat"
    #IO.inspect word 
    initword = word |> Enum.reduce([],fn(_,acc)->["_"|acc] end)
    spawn(Hangman.Game,:play,[word,%Game_record{letters: initword}])
  end

  
  def new_game() do
    Dictionary.random_word()|>
    init_game
  end

  
  def tally(game) do
    send game, {self(), :get_information}
    receive_msg()
  end

  def make_move(game,guess) do
    send game, {self(), :move, guess}
    receive_msg()
  end
end
