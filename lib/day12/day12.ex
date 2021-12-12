defmodule Day12 do
  def get_input() do
    Helpers.IO.stream_trimmed_lines("./input/day12/input.txt")
    |> Enum.map(&String.split(&1, "-", trim: true))
    |> Enum.map(fn [v1, v2] -> %Graph.Edge{v1: v1, v2: v2} end)
  end

  def puzzle1 do
    get_input()
    |> Graph.new
    |> CaveMap.find_exit_paths(:puzzle1)
    |> length
  end

  def puzzle2 do
    get_input()
    |> Graph.new
    |> CaveMap.find_exit_paths(:puzzle2)
     |> length
  end
end
