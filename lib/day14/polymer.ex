defmodule Day14.Polymer do
  def polymerize(result, _, 0) do
    result
  end

  def polymerize(template, rules, n) do
    polymerize(step(String.graphemes(template), rules, ""), rules, n - 1)
  end

  def step([current, next], rules, result) do
    result <> current <> rules[{current, next}] <> next
  end

  def step([current, next | template], rules, result) do
    step([next | template], rules, result <> current <> rules[{current, next}])
  end
end
