defmodule Dictionary do

  defdelegate random_word(), to: Dictionary.WordList

end
