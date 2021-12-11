defmodule Octopus do
  @enforce_keys [:energy]
  defstruct [:energy, flashed: false]

  defp neighbors({x, y}) do
    up = {x, y + 1}
    upleft = {x - 1, y + 1}
    left = {x - 1, y}
    downleft = {x - 1, y - 1}
    down = {x, y - 1}
    downright = {x + 1, y - 1}
    right = {x + 1, y}
    upright = {x + 1, y + 1}
    [up, upleft, left, downleft, down, downright, right, upright]
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
    {octopi, new_flashes} = step(octopi)
    if new_flashes == map_size(octopi) do
      step
    else
      simulate(octopi, step + 1, flashes + new_flashes, :puzzle2)
    end
  end

  defp step(octopi) do
    to_update = Enum.reduce(octopi, [], fn {pos, _}, acc -> [pos | acc] end)
    substep(octopi, to_update)
  end

  defp substep(octopi, []) do
    # flashes = Enum.count(octopi, fn {_, octopus} -> octopus.flashed end)
    flashes = Enum.count(octopi, fn {_, octopus} -> octopus.energy > 9 end)

    # Reset all octopi that flashed during the step
    octopi = Enum.reduce(
      octopi,
      %{},
      fn {pos, octopus}, acc ->
        case octopus.flashed do
          true -> Map.put(acc, pos, %Octopus{energy: 0, flashed: false})
          false -> Map.put(acc, pos, octopus)
        end
      end
    )
    {octopi, flashes}
  end

  defp substep(octopi, [head | tail]) do
    case Map.get(octopi, head) do
      # Skip locations outside map
      nil -> substep(octopi, tail)
      _ -> update(octopi, [head | tail])
    end
  end

  def update(octopi, [head | tail]) do
    # Increment current octopus
    octopus = Map.get(octopi, head)
    octopus = %Octopus{energy: octopus.energy + 1, flashed: octopus.flashed}

    # Only flash once per step
    if octopus.energy == 10 do
      # Set current octopus as flashed
      octopi = Map.put(octopi, head, %Octopus{energy: octopus.energy, flashed: true})
      # Add all neighbors at the back of update queue before updating
      substep(octopi, tail ++ neighbors(head))
    else
      # Update map with incremented octopus
      octopi = Map.put(octopi, head, octopus)
      substep(octopi, tail)
    end
  end

end
