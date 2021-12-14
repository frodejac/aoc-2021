defmodule Day14 do
  def parse_rules(raw_rules) do
    raw_rules
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " -> "))
    |> Enum.map(fn [pair, insertion_element] ->
      [List.to_tuple(String.graphemes(pair)), insertion_element]
    end)
    |> Enum.reduce(%{}, fn [{first, second}, insertion_element], acc ->
      Map.put(acc, {first, second}, [{first, insertion_element}, {insertion_element, second}])
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
    Day14.Polymer.run_polymerization(template, rules, 10)
  end

  def puzzle2 do
    {template, rules} = get_input()
    Day14.Polymer.run_polymerization(template, rules, 40)
  end
end
