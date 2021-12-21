defmodule Day19 do
  alias Day19.Scanner, as: Scanner

  def get_input() do
    File.read!("./input/day19/input.txt")
    |> String.split(~r/--- scanner [0-9]+ ---/, trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
    |> Enum.map(
      &Enum.map(&1, fn s ->
        Enum.map(String.split(s, ","), fn i -> String.to_integer(i) end) |> List.to_tuple()
      end)
    )
    |> Enum.map(&Scanner.new/1)
  end

  def puzzle1 do
    get_input()
    |> Scanner.align()
    |> Enum.reduce([], fn scanner, acc -> acc ++ scanner.beacons end)
    |> MapSet.new()
    |> MapSet.size()
  end

  def puzzle2 do
    get_input()
    |> Scanner.align()
    |> Enum.map(fn scanner -> scanner.translation end)
    |> Scanner.distances()
    |> Enum.max()
  end
end
