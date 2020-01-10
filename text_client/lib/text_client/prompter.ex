defmodule TextClient.Prompter do
  alias TextClient.State

  def accept_move(game = %State{}) do
    IO.gets("Your guess: ")
    |> check_input(game)
  end

  def check_input({:error, reason}, _) do
    IO.puts("Game ended: #{reason}")
  end

  def check_input(_eof = nil, _) do
    IO.puts("Look likes you gave up...")
  end

  def check_input(input, game = %State{}) do
    input = String.trim(input)

    cond do
      input =~ ~r/\A[a-z]\z/ ->
        Map.put(game, :guess, input)

      true ->
        IO.puts("please enter a singlecase letter")
        accept_move(game)
    end
  end
end
