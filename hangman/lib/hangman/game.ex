defmodule Hangman.Game do
  defstruct(
    game_state: :initializing,
    turns_left: 7,
    letters: [],
    used: MapSet.new()
  )

  def new_game() do
    new_game(Dictionary.random_word())
  end

  def new_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints()
    }
  end

  def make_move(game = %{game_state: state}, _guess) when state in [:won, :lost] do
    game
  end

  def make_move(game, guess) do
    accept_move(game, guess, MapSet.member?(game.used, guess))
  end

  def tally(game) do
    %{
      game: game.game_state,
      turns_left: game.turns_left,
      letters: game.letters |> reveal_letters(game.used)
    }
  end

  defp accept_move(game, _guess, _guess_already_used = true) do
    Map.put(game, :game_state, :already_used)
  end

  defp accept_move(game, guess, _guess_already_used) do
    Map.put(game, :used, MapSet.put(game.used, guess))
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, true) do
    new_state =
      MapSet.new(game.letters)
      |> MapSet.subset?(game.used)
      |> maybe_won()

    Map.put(game, :game_state, new_state)
  end

  defp score_guess(game = %{turns_left: 1}, _) do
    Map.put(game, :game_state, :lost)
  end

  defp score_guess(game = %{turns_left: turns_left}, _) do
    %{game | game_state: :bad_guess, turns_left: turns_left - 1}
  end

  defp reveal_letters(letters, used) do
    letters
    |> Enum.map(fn letter -> reveal_letter(letter, MapSet.member?(used, letter)) end)
  end

  defp reveal_letter(letter, _in_word = true), do: letter
  defp reveal_letter(_, _in_not_word), do: "_"

  defp maybe_won(true), do: :won
  defp maybe_won(_), do: :good_guess
end
