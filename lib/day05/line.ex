defmodule Day05.Line do

  defstruct [:x1, :y1, :x2, :y2]

  def points(line) when line.x1 == line.x2 do
    for y <- line.y1..line.y2 do
      {line.x1, y}
    end
  end

  def points(line) when line.y1 == line.y2 do
    for x <- line.x1..line.x2 do
      {x, line.y1}
    end
  end

  def points(line) do
    Enum.zip(
      line.x1..line.x2 |> Enum.to_list,
      line.y1..line.y2 |> Enum.to_list
    )
  end

  def horizontal?(line), do: line.y1 == line.y2
  def vertical?(line), do: line.x1 == line.x2

end
