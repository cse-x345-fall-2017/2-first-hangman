defmodule Hangman.Tool do
  
  #List.duplicate/2
  def get_letters(0),    do: []
  def get_letters(n),    do: ["_"] ++  get_letters(n-1)

  defmacro is_a_letter(guess) do
    quote do: is_bitstring(unquote(guess)) and String.length(unquote(guess)) == 1
  end

  def combine(list_a, _, 0), do: list_a

  def combine(list_a, list_b, n) do
    if Enum.at(list_a, n-1) == "_" do
      combine(List.replace_at(list_a, n-1, Enum.at(list_b, n-1)), list_b, n-1)
    else
      combine(list_a, list_b, n-1)
    end
  end
  
end
    
