defmodule Octopus do
  alias Helpers.Geometry, as: Geometry

  defp count_flashes(octopi), do: Enum.count(octopi, fn {_, octopus} -> octopus > 9 end)

  defp reset_flashed(octopi) do
    Enum.reduce(
      octopi,
      %{},
      fn {pos, octopus}, acc ->
        case octopus > 9 do
          true -> Map.put(acc, pos, 0)
          false -> Map.put(acc, pos, octopus)
        end
      end
    )
  end

  def simulate(octopi, steps, puzzle \\ :puzzle1) do
    simulate(octopi, steps, 0, puzzle)
  end

  def simulate(_, 0, flashes, :puzzle1), do: flashes

  def simulate(octopi, steps, flashes, :puzzle1) do
    {octopi, new_flashes} = step(octopi)
    simulate(octopi, steps - 1, flashes + new_flashes, :puzzle1)
  end

  def simulate(octopi, step, flashes, :puzzle2) do
    octopi_count = map_size(octopi)

    case step(octopi) do
      {_, ^octopi_count} -> step
      {octopi, new_flashes} -> simulate(octopi, step + 1, flashes + new_flashes, :puzzle2)
    end
  end

  defp step(octopi) do
    substep(octopi, Map.keys(octopi))
  end

  defp substep(octopi, []) do
    {reset_flashed(octopi), count_flashes(octopi)}
  end

  defp substep(octopi, [head | tail]) do
    case octopi[head] do
      # Skip locations outside map
      nil -> substep(octopi, tail)
      _ -> update(octopi, [head | tail])
    end
  end

  def update(octopi, [head | tail]) do
    case octopi[head] do
      # If octopus energy level == 9, increment and add neighbors to update queue
      9 -> substep(Map.put(octopi, head, 10), tail ++ Geometry.neighbors(head))
      # Otherwise, just increment
      x -> substep(Map.put(octopi, head, x + 1), tail)
    end
  end
end
