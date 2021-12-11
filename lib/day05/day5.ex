defmodule Day05 do

  alias Day05.Line, as: Line

  def read_input do
    File.stream!("./input/day05/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " -> ", trim: true))
    |> Stream.map(fn list -> Enum.flat_map(list, &String.split(&1, ",")) end)
    |> Stream.map(fn list -> Enum.map(list, &String.to_integer/1) end)
    |> Stream.map(fn [x1, y1, x2, y2] -> %Line{x1: x1, y1: y1, x2: x2, y2: y2} end)
    |> Enum.to_list
  end

  def puzzle1 do
    read_input()
    |> Enum.filter(fn line -> Line.horizontal?(line) || Line.vertical?(line) end)
    |> Enum.flat_map(&Line.points/1)
    |> Enum.reduce(%{}, fn point, acc -> Map.update(acc, point, 1, fn existing -> existing + 1 end) end)
    |> Enum.filter(fn {_, value} -> value >= 2 end)
    |> length
  end

  def puzzle2 do
    read_input()
    |> Enum.flat_map(&Line.points/1)
    |> Enum.reduce(%{}, fn point, acc -> Map.update(acc, point, 1, fn existing -> existing + 1 end) end)
    |> Enum.filter(fn {_, value} -> value >= 2 end)
    |> length
  end

end
