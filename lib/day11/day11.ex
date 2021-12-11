defmodule Day11 do
  def get_input() do
    File.stream!("./input/day11/input.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.graphemes/1)
    |> Stream.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    |> Stream.map(&Enum.with_index/1)
    |> Stream.with_index
    |> Enum.flat_map(
         fn {array, y_idx} -> Enum.reduce(array, [], fn {value, x_idx}, acc -> List.insert_at(acc, -1, {{x_idx, y_idx}, value}) end)
         end
       )
    |> Enum.reduce(%{}, fn {{x, y}, energy}, acc -> Map.put(acc, {x, y}, %Octopus{energy: energy, flashed: false}) end)
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
