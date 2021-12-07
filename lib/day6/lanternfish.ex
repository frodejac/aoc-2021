defmodule Day6.Lanternfish do

  # ---------- NAIVE SOLUTION -----------
  # This solution gets way too slow when number of iterations gets above 100 or so
  def new_naive() do
    8
  end

  def step_naive(lanternfish) when lanternfish == 0, do: [6, new_naive()]
  def step_naive(lanternfish), do: [lanternfish - 1]

  def simulate_naive(lanternfishes, days) when days > 0 do
    lanternfishes = Enum.flat_map(lanternfishes, &step_naive/1)
    simulate_naive(lanternfishes, days - 1)
  end

  def simulate_naive(lanternfishes, days) do
    lanternfishes
  end

  def count_naive(lanternfishes), do: length(lanternfishes)

  # ---------- EFFICIENT SOLUTION -----------
  # Instead of keeping track of the age of individual lanternfish, only keep
  # track of the number of lanternfish at each age

  def new(), do: (for _ <- 0..8, do: 0)

  def new(input) do
    Enum.reduce(input, new(), fn age, acc -> List.update_at(acc, age, &(&1 + 1)) end)
  end

  def step([head | tail]) do
    # Cycle list and reset age of the fish that spawned new ones
    spawning_count = Enum.at([head | tail], 0)
    tail ++ [head]
    |> List.update_at(6, &(&1 + spawning_count))
  end

  def simulate(population, days) when days == 0 do
    population
  end

  def simulate(population, days) do
    population
    |> step()
    |> simulate(days - 1)
  end

  def count(population) do
    Enum.reduce(population, 0, fn age, acc -> acc + age end)
  end


end
