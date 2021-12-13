defmodule Day09 do
  alias Day09.LavaVents, as: LavaVents

  def get_input() do
    Helpers.IO.stream_list_of_integers("./input/day09/input.txt")
    |> Stream.map(&Enum.with_index/1)
    |> Stream.with_index()
    |> Enum.map(fn {array, y_idx} ->
      Enum.reduce(array, [], fn {value, x_idx}, acc ->
        List.insert_at(acc, -1, {{x_idx, y_idx}, value})
      end)
    end)
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
