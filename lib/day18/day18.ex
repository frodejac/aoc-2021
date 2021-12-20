defmodule Day18 do
  import Day18.Snailfish.Number

  def get_input() do
    Helpers.IO.stream_trimmed_lines("./input/day18/input.txt")
    |> Enum.map(&new/1)
  end

  def puzzle1() do
    [first | rest] = get_input()

    Enum.reduce(rest, first, fn num, acc -> reduce(add(acc, num)) end)
    |> magnitude()
  end

  def puzzle2() do
    numbers = get_input()
    mags = calculate_magnitudes(numbers)
    Enum.max(mags)
  end

  def calculate_magnitudes([_]) do
    []
  end

  def calculate_magnitudes([first | rest]) do
    mags =
      Enum.flat_map(
        rest,
        fn number ->
          [magnitude(reduce(add(first, number))), magnitude(reduce(add(number, first)))]
        end
      )

    mags ++ calculate_magnitudes(rest)
  end
end
