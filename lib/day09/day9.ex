defmodule Day09 do

  alias Day09.LavaVents, as: LavaVents

  def get_input() do
    File.stream!("./input/day9/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    |> Stream.map(&Enum.with_index/1)
    |> Stream.with_index
    |> Enum.map(
         fn {array, y_idx} -> Enum.reduce(array, [], fn {value, x_idx}, acc -> List.insert_at(acc, -1, {{x_idx, y_idx}, value}) end)
         end
       )
  end

  def puzzle1 do
    get_input()
    |> LavaVents.calculate_risk()
  end

  def puzzle2 do
    get_input()
    |> LavaVents.find_basin_sizes()
    |> Enum.sort(&>/2)
    |> Enum.take(3)
    |> Enum.reduce(1, fn size, acc -> acc * size end)
  end
end
