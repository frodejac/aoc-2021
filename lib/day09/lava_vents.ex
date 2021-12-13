defmodule Day09.LavaVents do
  alias Day09.Extrema, as: Extrema

  def calculate_risk(input) do
    minima = Extrema.find_local_minima_2d(input)

    input
    |> List.flatten()
    |> Enum.reduce(0, fn {{x, y}, value}, acc ->
      if MapSet.member?(minima, {x, y}), do: acc + value + 1, else: acc
    end)
  end

  def find_basin_sizes(input) do
    minima = Extrema.find_local_minima_2d(input)

    heightmap =
      input
      |> List.flatten()
      |> Enum.reduce(
        %{},
        fn {{x, y}, value}, acc -> Map.put(acc, {x, y}, value) end
      )

    minima
    |> Enum.map(&find_basin_size(&1, heightmap))
  end

  def find_basin_size(minimum, heightmap), do: find_basin_size(minimum, heightmap, MapSet.new())

  def find_basin_size(minimum, heightmap, basin) do
    {_, basin} = flow(minimum, {heightmap, basin})
    MapSet.size(basin)
  end

  def flow({x, y}, {heightmap, basin}) do
    cond do
      # Outside map
      Map.get(heightmap, {x, y}) == nil -> {heightmap, basin}
      # Already visited
      MapSet.member?(basin, {x, y}) -> {heightmap, basin}
      # Edge of basin
      Map.get(heightmap, {x, y}) == 9 -> {heightmap, basin}
      # Unvisited part of basin
      true -> visit({x, y}, {heightmap, basin})
    end
  end

  def visit({x, y}, {heightmap, basin}) do
    # Add point to basin and flow in all directions
    MapSet.put(basin, {x, y})
    |> (&flow({x, y - 1}, {heightmap, &1})).()
    |> (&flow({x - 1, y}, &1)).()
    |> (&flow({x, y + 1}, &1)).()
    |> (&flow({x + 1, y}, &1)).()
  end
end
