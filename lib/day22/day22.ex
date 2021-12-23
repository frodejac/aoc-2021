defmodule Day22 do
  alias Day22.Instruction, as: Instruction

  def get_input() do
    Helpers.IO.stream_trimmed_lines("./input/day22/input.txt")
    |> Stream.map(&Instruction.new/1)
    |> Enum.to_list()
  end

  def puzzle1() do
    cuboids =
      get_input()
      |> Enum.take_while(fn instruction ->
        Instruction.inside?(instruction, {{-50, -50, -50}, {50, 50, 50}})
      end)
      |> Day22.Reactor.startup()

    for {x, y, z} <- cuboids, reduce: 0 do
      sum -> sum + Enum.count(x) * Enum.count(y) * Enum.count(z)
    end
  end

  def puzzle2() do
    cuboids =
      get_input()
      |> Day22.Reactor.startup()

    for {x, y, z} <- cuboids, reduce: 0 do
      sum -> sum + Enum.count(x) * Enum.count(y) * Enum.count(z)
    end
  end
end
