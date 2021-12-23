defmodule DiracDice.Dice do
  defstruct [:stream, :index]

  def new(stream) do
    %DiracDice.Dice{stream: stream, index: 0}
  end

  def roll(dice, n \\ 3) do
    moves =
      dice.stream
      |> Stream.drop(dice.index)
      |> Stream.take(n)
      |> Enum.sum()

    {moves, %DiracDice.Dice{dice | index: dice.index + n}}
  end

  def quantum_rolls(),
    do:
      for(i <- 1..3, j <- 1..3, k <- 1..3, do: i + j + k)
      |> Enum.frequencies()
end
