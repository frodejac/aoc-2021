defmodule Day14 do
  def parse_rules(raw_rules) do
    raw_rules
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.reduce(%{}, fn [pair, insertion_element], acc ->
      Map.put(acc, List.to_tuple(String.graphemes(pair)), insertion_element)
    end)
  end

  def get_input() do
    [template, rules] =
      File.read!("./input/day14/input.txt")
      |> String.split("\n\n")

    {template, parse_rules(rules)}
  end

  def puzzle1 do
    {template, rules} = get_input()

    {{_, min}, {_, max}} =
      Day14.Polymer.polymerize(template, rules, 10)
      |> String.graphemes()
      |> Enum.reduce(%{}, fn s, acc -> Map.update(acc, s, 1, &(&1 + 1)) end)
      |> Enum.min_max_by(fn {_, value} -> value end)

    max - min
  end
end
