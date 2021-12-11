defmodule Day11 do
  def get_input() do
    Helpers.IO.read_as_2d_map("./input/day11/input.txt")
  end

  def puzzle1() do
    get_input()
    |> Octopus.simulate(100)
  end

  def puzzle2() do
    get_input()
    |> Octopus.simulate(1, :puzzle2)
  end
end
