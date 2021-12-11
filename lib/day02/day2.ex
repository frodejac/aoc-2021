defmodule Day02 do
  @moduledoc false

  defp move({direction, distance}, {x, y}) do
    case direction do
      "forward" -> {x + distance, y}
      "up" -> {x, y - distance}
      "down" -> {x, y + distance}
    end
  end

  defp move({direction, delta}, {x, y, aim}) do
    case direction do
      "forward" -> {x + delta, y + (aim * delta), aim}
      "up" -> {x, y, aim - delta}
      "down" -> {x, y, aim + delta}
    end
  end

  def puzzle1() do
    File.stream!("./input/day02/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn list -> [Enum.at(list, 0), String.to_integer(Enum.at(list, 1))] end)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.reduce({0, 0}, fn movement, acc -> move(movement, acc) end)
    |> Tuple.to_list
    |> Enum.reduce(1, fn factor, acc -> factor * acc end)
  end

  def puzzle2() do
    File.stream!("./input/day02/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " "))
    |> Stream.map(fn list -> [Enum.at(list, 0), String.to_integer(Enum.at(list, 1))] end)
    |> Stream.map(&List.to_tuple/1)
    |> Enum.reduce({0, 0, 0}, fn movement, acc -> move(movement, acc) end)
    |> Tuple.to_list
    |> Enum.take(2)
    |> Enum.reduce(1, fn factor, acc -> factor * acc end)
  end

end
