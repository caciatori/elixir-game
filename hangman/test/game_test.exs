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
      assert { ^game, _tally } = Game.make_move(game, "")
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
    game = Game.new_game("elixir")
    { game, _tally } = Game.make_move(game, "e")
    assert game.game_state == :good_guess
  end

  test "recognize a good guess with Enum reduce function" do
    moves = [
      {"e", :good_guess, 7},
      {"l", :good_guess, 7},
      {"i", :good_guess, 7},
      {"x", :good_guess, 7},
      {"r", :won, 7}
    ]

    game = Game.new_game("elixir")

    Enum.reduce(moves, game, fn {guess, expect_state, expect_turns_left}, game ->
      { game, _tally } = Game.make_move(game, guess)
      assert game.game_state == expect_state
      assert game.turns_left == expect_turns_left
      game
    end)
  end

  test "bad guess is recognized" do
    game = Game.new_game("elixir")
    { game, _tally } = Game.make_move(game, "a")
    assert game.game_state == :bad_guess
    assert game.turns_left == 6
  end

  test "recognize a bad guess with Enum reduce function" do
    moves = [
      {"a", :bad_guess, 6},
      {"b", :bad_guess, 5},
      {"c", :bad_guess, 4},
      {"d", :bad_guess, 3},
      {"f", :bad_guess, 2},
      {"g", :bad_guess, 1},
      {"h", :lost, 1}
    ]

    game = Game.new_game("elixir")

    Enum.reduce(moves, game, fn {guess, expect_state, expect_turns_left}, game ->
      { game, _tally } = Game.make_move(game, guess)
      assert game.game_state == expect_state
      assert game.turns_left == expect_turns_left
      game
    end)
  end
end
