defmodule Day25 do
  def get_input() do
    Helpers.IO.read_as_2d_map_of_strings("./input/day25/input.txt")
  end

  def puzzle1() do
    get_input()
    |> Cucumber.new()
    |> Cucumber.run()
  end

  def puzzle2() do
  end
end
