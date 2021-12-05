defmodule Day3 do
  @moduledoc false

  # Data structure should look something like
  # %{<pos>: %{0: <count>, 1: <count>}, ...}

  def gamma(histogram) do
    for {_, count} <- histogram, into: "" do
      cond do
        count[0] > count[1] -> "0"
        count[1] > count[0] -> "1"
        True -> raise "Cannot determine binary digit"
      end
    end
    |> String.to_integer(2)
  end

  def epsilon(histogram) do
    for {_, count} <- histogram, into: "" do
      cond do
        count[0] < count[1] -> "0"
        count[1] < count[0] -> "1"
        True -> raise "Cannot determine binary digit"
      end
    end
    |> String.to_integer(2)
  end

  def puzzle1() do
    histogram = File.stream!("./input/day3/input1.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    |> Stream.map(&Enum.with_index(&1))
    |> Stream.map(&Enum.reduce(&1, %{}, fn {bit, pos}, acc -> Map.update(acc, pos, %{%{0 => 0, 1 => 0} | bit => 1}, fn _ -> nil end) end))
    |> Enum.reduce(%{}, fn m, acc -> Map.merge(acc, m, fn _k, m1, m2 -> Map.merge(m1, m2, fn _k, v1, v2 -> v1 + v2 end) end ) end)

    rates = %{epsilon: epsilon(histogram), gamma: gamma(histogram)}
    rates.epsilon * rates.gamma

  end

end
