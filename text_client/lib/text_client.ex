defmodule TextClient do
  alias TextClient.{Player, State}

  def start() do
    Hangman.new_game()
    |> setup_game()
    |> Player.play()
  end

  def setup_game(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game)
    }
  end
end
