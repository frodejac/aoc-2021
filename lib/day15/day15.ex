defmodule Day15 do
  import Graph.Dijkstra

  def puzzle1 do
    graph = Helpers.IO.read_as_2d_map("./input/day15/input.txt")

    target =
      Enum.max(graph)
      |> elem(0)

    dijkstra(graph, {0, 0}, target)
  end

  def puzzle2 do
    graph = Helpers.IO.read_as_2d_map("./input/day15/input.txt")
    {{size_x, _}, _} = Enum.max_by(graph, fn {{x, _}, _} -> x end)
    {{_, size_y}, _} = Enum.max_by(graph, fn {{_, y}, _} -> y end)

    extended_graph = extend_graph(Map.to_list(graph), %{}, {size_x, size_y})

    target =
      Enum.max(extended_graph)
      |> elem(0)

    dijkstra(extended_graph, {0, 0}, target)
  end

  def extend_graph([], extended_graph, _) do
    extended_graph
  end

  def extend_graph([{{x, y}, cost} | tail], extended_graph, {size_x, size_y}) do
    extend_graph(
      tail,
      Map.merge(
        extended_graph,
        Enum.reduce(
          0..4,
          %{},
          fn tile_x, acc ->
            Enum.reduce(
              0..4,
              acc,
              fn tile_y, acc ->
                Map.put(
                  acc,
                  {tile_x * size_x + x, tile_y * size_y + y},
                  Enum.at(Stream.cycle(1..9), cost + tile_x + tile_y - 1)
                )
              end
            )
          end
        )
      ),
      {size_x, size_y}
    )
  end
end
