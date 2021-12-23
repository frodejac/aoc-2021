defmodule DiracDice.Player do
  defstruct [:position, :score]

  def new(starting_position) do
    %DiracDice.Player{position: starting_position, score: 0}
  end

  def move(player, spaces) do
    position =
      Stream.cycle(1..10)
      |> Stream.drop(player.position - 1)
      |> Enum.at(spaces)

    %DiracDice.Player{position: position, score: player.score + position}
  end
end
