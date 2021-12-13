defmodule Day07 do
  alias Day07.Crab, as: Crab

  def get_input() do
    File.stream!("./input/day07/input.txt")
    |> Stream.flat_map(&String.split(&1, ",", trim: true))
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list()
  end

  def puzzle1 do
    get_input()
    |> Crab.setup()
    |> Crab.cost_of_cheapest_common_position(:simple)
  end

  def puzzle2 do
    get_input()
    |> Crab.setup()
    |> Crab.cost_of_cheapest_common_position(:complex)
  end
end
