defmodule TextClient do
  alias TextClient.{Player, State}

  @hangman_server :"hangman@luizgsc-Latitude-3480"

  def start() do
    new_game()
    |> setup_game()
    |> Player.play()
  end

  defp setup_game(game) do
    %State{
      game_service: game,
      tally: Hangman.tally(game)
    }
  end

  defp new_game() do
    Node.connect(@hangman_server)
    :rpc.call(@hangman_server, Hangman, :new_game, [])
  end
end
