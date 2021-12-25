defmodule Day23 do
  alias Day23.AmphipodGame, as: AmphipodGame

  def get_input() do
    File.read!("./input/day23/input.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(
      &(Regex.scan(~r/[A-D]/, &1)
        |> List.flatten())
    )
    |> Enum.reject(fn
      [] -> true
      _ -> false
    end)
    |> Enum.map(fn row ->
      Enum.map(
        row,
        fn
          "A" -> 0
          "B" -> 1
          "C" -> 2
          "D" -> 3
        end
      )
    end)
  end

  def puzzle1 do
    # First solved by hand:
    # 14350
    get_input()
    |> AmphipodGame.new()
    |> AmphipodGame.find_cheapest_solution()

  end

  def puzzle2 do
    [r1, r2] = get_input()

    [
      r1,
      [3, 2, 1, 0],
      [3, 1, 0, 2],
      r2
    ]
    |> AmphipodGame.new()
    |> AmphipodGame.find_cheapest_solution()
  end
end
