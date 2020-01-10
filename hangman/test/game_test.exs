defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game returns structure" do
    game = Game.new_game()

    assert game.game_state == :initializing
    assert game.turns_left == 7
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert { ^game, _} = Game.make_move(game, "")
    end
  end

  test "first occourrence of the letter is not already used" do
    game = Game.new_game()
    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occourrence of the letter is already used" do
    game = Game.new_game()

    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state != :already_used

    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "validate a good guess" do
    game = Game.new_game("Elixir")
    { game, _tally } = Game.make_move(game, "E")
    assert game.game_state == :good_guess

    { game, _tally } = Game.make_move(game, "l")
    assert game.game_state == :good_guess

    { game, _tally } = Game.make_move(game, "i")
    assert game.game_state == :good_guess

    { game, _tally } = Game.make_move(game, "x")
    assert game.game_state == :good_guess

    { game, _tally } = Game.make_move(game, "r")
    assert game.game_state == :won
  end
end
