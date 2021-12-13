defmodule Day07.Crab do
  defstruct [:x]

  def new(x), do: %Day07.Crab{x: x}

  def setup(input), do: input |> Enum.map(&new/1)

  def movecost(crab, x, :simple), do: abs(crab.x - x)

  def movecost(crab, x, :complex) do
    0..abs(crab.x - x)
    |> Enum.sum()
  end

  def compare(crab1, crab2) do
    cond do
      crab1.x > crab2.x -> :gt
      crab1.x < crab2.x -> :lt
      true -> :eq
    end
  end

  def total_cost(crabs, pos, costfunc \\ :simple) do
    crabs
    |> Enum.map(&movecost(&1, pos, costfunc))
    |> Enum.sum()
  end

  def cheapest_common_position(crabs, costfunc \\ :simple) do
    0..Enum.max(crabs, Day07.Crab).x
    |> Enum.map(fn pos -> {pos, Day07.Crab.total_cost(crabs, pos, costfunc)} end)
    |> Enum.min(fn {_, cost1}, {_, cost2} -> cost1 <= cost2 end)
  end

  def cost_of_cheapest_common_position(crabs, costfunc \\ :simple) do
    {_, cost} = cheapest_common_position(crabs, costfunc)
    cost
  end
end
