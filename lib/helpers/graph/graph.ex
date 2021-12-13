defmodule Graph do
  defstruct [:vertices, :edges, :adjacency]

  def neighbors(graph, vertex) do
    graph.adjacency[vertex]
  end

  def new(edges) do
    %Graph{vertices: get_vertices(edges), edges: edges, adjacency: create_adjacency(edges)}
  end

  defp get_vertices(edges) do
    edges
    |> Enum.flat_map(fn edge -> [edge.v1, edge.v2] end)
    |> MapSet.new()
    |> Enum.reduce(%{}, fn vertex, acc -> Map.put(acc, vertex, 0) end)
  end

  defp create_adjacency(edges) do
    Enum.reduce(edges, %{}, fn edge, acc -> add_adjacency(acc, edge) end)
  end

  def add_adjacency(adjacency, edge) do
    adjacency
    |> Map.update(edge.v1, MapSet.new([edge.v2]), fn existing -> MapSet.put(existing, edge.v2) end)
    |> Map.update(edge.v2, MapSet.new([edge.v1]), fn existing -> MapSet.put(existing, edge.v1) end)
  end

  def visit_vertex(graph, vertex) do
    %Graph{
      vertices: Map.update(graph.vertices, vertex, 0, &(&1 + 1)),
      edges: graph.edges,
      adjacency: graph.adjacency
    }
  end
end
