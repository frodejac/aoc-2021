defmodule DiracDice do
  def turn(player, dice) do
    {moves, dice} = DiracDice.Dice.roll(dice)
    player = DiracDice.Player.move(player, moves)

    cond do
      player.score >= 1000 -> {:stop, player, dice}
      true -> {:continue, player, dice}
    end
  end

  def play(player1, player2, dice) do
    {status, player1, dice} = turn(player1, dice)

    if status == :stop do
      %{
        winner: player1,
        loser: player2,
        dice: dice
      }
    else
      {status, player2, dice} = turn(player2, dice)

      if status == :stop do
        %{
          winner: player2,
          loser: player1,
          dice: dice
        }
      else
        play(player1, player2, dice)
      end
    end
  end

  def move(pos, roll), do: rem(pos + roll - 1, 10) + 1

  def update_score({pos, score}, roll) do
    new_pos = move(pos, roll)
    {new_pos, score + new_pos}
  end

  def play_quantum({_, {_, score}}) when score >= 21, do: {0, 1}

  def play_quantum({player1, player2}) do
    DiracDice.Dice.quantum_rolls()
    |> Enum.map(fn {roll, count} ->
      {p2_wins, p1_wins} =
        Memoize.memoized(&play_quantum/1, {player2, update_score(player1, roll)})

      {count * p1_wins, count * p2_wins}
    end)
    |> Enum.reduce(fn {p1_wins, p2_wins}, {acc_p1_wins, acc_p2_wins} ->
      {acc_p1_wins + p1_wins, acc_p2_wins + p2_wins}
    end)
  end
end
