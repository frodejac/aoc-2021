defmodule Day13.Fold do
  defstruct [:axis, :pos]

  def new(axis, pos) do
    %Day13.Fold{axis: axis, pos: pos}
  end

  def fold(points, []) do
    points
  end

  def fold(points, [head | tail]) do
    fold(fold(points, head), tail)
  end

  def fold(points, fold) when is_list(points) do
    points
    |> Enum.map(&fold(&1, fold))
    |> Enum.uniq()
  end

  def fold(point, fold) do
    case fold.axis do
      "x" -> fold(point, fold, :vertical)
      "y" -> fold(point, fold, :horizontal)
    end
  end

  def fold({x, y}, fold, :vertical) do
    cond do
      x > fold.pos -> {x - 2 * (x - fold.pos), y}
      true -> {x, y}
    end
  end

  def fold({x, y}, fold, :horizontal) do
    cond do
      y > fold.pos -> {x, y - 2 * (y - fold.pos)}
      true -> {x, y}
    end
  end
end
