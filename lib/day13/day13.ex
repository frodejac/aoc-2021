defmodule Day13 do
  def get_dots(raw_dots) do
    raw_dots
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ",", trim: true))
    |> Enum.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
    |> Enum.map(&List.to_tuple/1)
  end

  def get_folds(raw_folds) do
    raw_folds
    |> String.split("\n")
    |> Enum.map(&String.trim_leading(&1, "fold along "))
    |> Enum.map(&String.split(&1, "="))
    |> Enum.map(fn [axis, pos] -> Day13.Fold.new(axis, String.to_integer(pos)) end)
  end

  def get_input() do
    [dots, folds] =
      File.read!("./input/day13/input.txt")
      |> String.split("\n\n")

    {get_dots(dots), get_folds(folds)}
  end

  def render(dots) do
    {max_x, _} = Enum.max_by(dots, fn {x, _} -> x end)
    {_, max_y} = Enum.max_by(dots, fn {_, y} -> y end)

    dots = MapSet.new(dots)

    for y <- 0..max_y, x <- 0..(max_x + 1) do
      cond do
        MapSet.member?(dots, {x, y}) -> "#"
        x == max_x + 1 -> "\n"
        true -> " "
      end
    end
    |> Enum.reduce("", fn s, acc -> acc <> s end)
  end

  def puzzle1 do
    {dots, folds} = get_input()

    Day13.Fold.fold(dots, Enum.at(folds, 0))
    |> length
  end

  def puzzle2 do
    {dots, folds} = get_input()
    render(Day13.Fold.fold(dots, folds))
  end
end
