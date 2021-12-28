defmodule Day24 do
  def get_input() do
    File.read!("./input/day24/input.txt")
  end

  def puzzle1() do
    get_input()
    |> Day24.Solver.new()
    |> IO.inspect()
    |> Day24.Solver.resolve_constraints(:high)
  end

  def puzzle2() do
    get_input()
    |> Day24.Solver.new()
    |> IO.inspect()
    |> Day24.Solver.resolve_constraints(:low)
  end
end
