defmodule Day6 do

  alias Day6.Lanternfish, as: Lanternfish

  def data() do
    File.stream!("./input/day6/input1.txt")
    |> Stream.flat_map(&String.split(&1, ",", trim: true))
    |> Stream.map(&String.to_integer/1)
    |> Enum.to_list
  end

  def puzzle1 do
    data()
    |> Lanternfish.new()
    |> Lanternfish.simulate(80)
    |> Lanternfish.count()
  end

  def puzzle2 do
    data()
    |> Lanternfish.new()
    |> Lanternfish.simulate(256)
    |> Lanternfish.count()
  end

  def puzzle3 do
    # Just for fun, this results in count with 37838 digits
    data()
    |> Lanternfish.new()
    |> Lanternfish.simulate(1000000)
    |> Lanternfish.count()
  end

end
