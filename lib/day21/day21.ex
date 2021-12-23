defmodule Day21 do
  def get_input() do
    File.read!("./input/day21/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.flat_map(&String.split(&1, ~r/Player [12] starting position: /, trim: true))
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&DiracDice.Player.new/1)
    |> List.to_tuple()
  end

  def puzzle1() do
    {player1, player2} = get_input()
    result = DiracDice.play(player1, player2, DiracDice.Dice.new(Stream.cycle(1..100)))
    result.loser.score * result.dice.index
  end

  def puzzle2() do
    {player1, player2} = get_input()

    DiracDice.play_quantum({{player1.position, player1.score}, {player2.position, player2.score}})
    |> Tuple.to_list()
    |> Enum.max()
  end
end
