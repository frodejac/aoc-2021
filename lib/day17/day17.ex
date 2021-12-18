defmodule Day17 do
  def get_input() do
    coords =
      File.read!("./input/day17/input.txt")
      |> String.trim_leading("target area: ")
      |> String.split(", ", trim: true)
      |> Enum.flat_map(&String.split(&1, ".."))
      |> Enum.map(&String.trim_leading(&1, "x="))
      |> Enum.map(&String.trim_leading(&1, "y="))
      |> Enum.map(&String.to_integer/1)

    Enum.zip([:x_min, :x_max, :y_min, :y_max], coords)
    |> Keyword.new()
  end

  def puzzle1 do
    target = get_input()

    Day17.TrickShot.grid_search_y(target[:y_min], target[:y_max])
    |> Enum.max()
    |> elem(1)
    |> Enum.max()
  end

  def puzzle2 do
    target = get_input()

    x_candidates = Day17.TrickShot.grid_search_x(target[:x_min], target[:x_max]) |> IO.inspect()
    y_candidates = Day17.TrickShot.grid_search_y(target[:y_min], target[:y_max]) |> IO.inspect()

    # For all possible initial condition pairs, check if any point in the zipped trajectories are inside target
    # Pad X trajectories with final value before zipping if Y trajectory is longer
    for {_, x_candidate} <- x_candidates, {_, y_candidate} <- y_candidates do
      if length(x_candidate) >= length(y_candidate) do
        Enum.any?(Enum.zip(x_candidate, y_candidate), fn pos ->
          Day17.TrickShot.inside?(pos, target)
        end)
      else
        x_candidate =
          x_candidate ++
            Enum.take(
              Stream.cycle([Enum.at(x_candidate, -1)]),
              length(y_candidate) - length(x_candidate)
            )

        Enum.any?(Enum.zip(x_candidate, y_candidate), fn pos ->
          Day17.TrickShot.inside?(pos, target)
        end)
      end
    end
    |> Enum.filter(& &1)
    |> length()
  end
end
