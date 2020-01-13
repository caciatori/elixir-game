defmodule Dictionary.Application do

  alias Dictionary.WordList

  def start(_type, _args) do
    WordList.start_link()
  end

end
