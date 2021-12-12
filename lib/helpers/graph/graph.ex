defmodule Graph do
  defstruct [:vertices, :adjacency]

  def neighbors(graph, vertex) do
    graph.adjacency[vertex]
  end

  def new(edges) do
    %Graph{vertices: get_vertices(edges), adjacency: create_adjacency(edges)}
  end

  def get_vertices(edges) do
    edges
    |> Enum.flat_map(fn edge -> [edge.v1, edge.v2] end)
    |> MapSet.new()
    |> Enum.reduce(%{}, fn vertex, acc -> Map.put(acc, vertex, 0) end)
  end

  def create_adjacency(edges) do
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
      adjacency: graph.adjacency,
    }
  end

  def can_visit?(graph, vertex, :puzzle1) do
    cond do
      Graph.Vertex.is_start?(vertex) -> false
      Graph.Vertex.is_big?(vertex) -> true
      true -> graph.vertices[vertex] < 1
    end
  end

  def can_visit?(graph, vertex, :puzzle2) do
    cond do
      Graph.Vertex.is_start?(vertex) ->
        false
      Graph.Vertex.is_big?(vertex) ->
        true
      Enum.any?(graph.vertices, fn {v, visits} -> !Graph.Vertex.is_big?(v) and visits > 1 end) ->
        graph.vertices[vertex] < 1
      true ->
        graph.vertices[vertex] < 2
    end
  end

end
