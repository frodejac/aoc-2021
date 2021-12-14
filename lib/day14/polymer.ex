defmodule Day14.Polymer do
  defp generate_pairs(template) when is_binary(template),
    do: generate_pairs(String.graphemes(template))

  defp generate_pairs([first, second]) do
    [{first, second}]
  end

  defp generate_pairs([first, second | template]) do
    [{first, second} | generate_pairs([second | template])]
  end

  defp count_pairs(pairs),
    do: Enum.reduce(pairs, %{}, fn pair, acc -> Map.update(acc, pair, 1, &(&1 + 1)) end)

  defp get_distribution(pair_counts) do
    pair_counts
    |> Enum.reduce(%{}, fn {{first, second}, count}, acc ->
      Map.update(acc, first, count, &(&1 + count))
      |> Map.update(second, count, &(&1 + count))
    end)
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      Map.put(acc, key, trunc(Float.ceil(value / 2)))
    end)
  end

  defp get_min_max(pair_distribution) do
    {{_, min}, {_, max}} = Enum.min_max_by(pair_distribution, fn {_, value} -> value end)
    {min, max}
  end

  def run_polymerization(template, rules, steps) do
    {min, max} =
      generate_pairs(template)
      |> count_pairs()
      |> polymerize(rules, steps)
      |> get_distribution()
      |> get_min_max()

    max - min
  end

  defp polymerize(result, _, 0) do
    result
  end

  defp polymerize(pairs, rules, n) do
    step(pairs, rules)
    |> polymerize(rules, n - 1)
  end

  defp step(pairs, rules),
    do: Enum.reduce(pairs, %{}, fn {pair, count}, acc -> update(acc, rules, pair, count) end)

  defp update(pairs, rules, pair, count) do
    [first, second] = rules[pair]

    pairs
    |> Map.update(first, count, &(&1 + count))
    |> Map.update(second, count, &(&1 + count))
  end
end
