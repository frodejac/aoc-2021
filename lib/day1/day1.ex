defmodule Day1 do
  def gradient_direction(a, b) do
    cond do
      a > b -> -1
      a < b -> 1
      True -> 0
    end
  end

  def count_positive_gradients([head | tail], previous, accumulator) do
    case gradient_direction(previous, head) do
      1 -> count_positive_gradients(tail, head, accumulator + 1)
      _ -> count_positive_gradients(tail, head, accumulator)
    end
  end

  def count_positive_gradients([], _, accumulator) do
    accumulator
  end

  def window([head | tail], window_size) do
    cond do
      length(tail) >= window_size - 1 ->
        [Enum.sum([head] ++ Enum.take(tail, window_size - 1))] ++ window(tail, window_size)
      True ->
        []
    end
  end

  def puzzle1() do
    InputReader.read_lines_as_integers("./input/day1/input1.txt")
    |> (fn [head | tail] -> count_positive_gradients(tail, head, 0) end).()
    |> IO.puts
  end

  def puzzle2() do
    InputReader.read_lines_as_integers("./input/day1/input1.txt")
    |> window(3)
    |> (fn [head | tail] -> count_positive_gradients(tail, head, 0) end).()
    |> IO.puts

  end
end
