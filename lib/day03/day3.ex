use Bitwise, only_operators: true

defmodule Day03 do
  @moduledoc false

  # ------------- PUZZLE 1 -----------------

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
    histogram = File.stream!("./input/day03/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, "", trim: true))
    |> Stream.map(&Enum.map(&1, fn x -> String.to_integer(x) end))
    |> Stream.map(&Enum.with_index(&1))
    |> Stream.map(&Enum.reduce(&1, %{}, fn {bit, pos}, acc -> Map.update(acc, pos, %{%{0 => 0, 1 => 0} | bit => 1}, fn _ -> nil end) end))
    |> Enum.reduce(%{}, fn m, acc -> Map.merge(acc, m, fn _k, m1, m2 -> Map.merge(m1, m2, fn _k, v1, v2 -> v1 + v2 end) end ) end)

    rates = %{epsilon: epsilon(histogram), gamma: gamma(histogram)}
    rates.epsilon * rates.gamma

  end

  # ------------- PUZZLE 2 -----------------

  def calculate_rating(data, cmp) do
    calculate_rating(data, 11, cmp)
  end

  def calculate_rating(data, n, cmp) when length(data) > 1 do
    distribution = Enum.group_by(data, fn x -> ((x &&& (1 <<< n)) >>> n) &&& 1 end)
    calculate_rating(distribution[cmp.(distribution)], n-1, cmp)
  end

  def calculate_rating(data, _, _) do
    Enum.at(data, 0)
  end


  def oxygen_generator_rating_cmp(dist) do
    cond do
      length(Map.get(dist, 1, [])) >= length(Map.get(dist, 0, [])) -> 1
      length(Map.get(dist, 0, [])) > length(Map.get(dist, 1, [])) -> 0
    end
  end

  def co2_scrubber_rating_cmp(dist) do
    cond do
      length(Map.get(dist, 0, [])) <= length(Map.get(dist, 1, [])) -> 0
      length(Map.get(dist, 1, [])) < length(Map.get(dist, 0, [])) -> 1
    end
  end

  def puzzle2() do
    data = File.stream!("./input/day03/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer(&1, 2))
    |> Enum.to_list

    ratings = %{
      oxygen: calculate_rating(data, &oxygen_generator_rating_cmp/1),
      co2: calculate_rating(data, &co2_scrubber_rating_cmp/1)
    }
    ratings.oxygen * ratings.co2
  end

end
