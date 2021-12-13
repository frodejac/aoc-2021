defmodule CaveMap do
  def find_exit_paths(graph, puzzle \\ :puzzle1) do
    explore(graph, puzzle)
    |> Enum.filter(fn path -> Enum.at(path, 0) == "end" end)
    |> Enum.map(&Enum.reverse/1)
  end

  def explore(graph, puzzle \\ :puzzle1) do
    # Finds all paths through graph (reversed)
    explore(Graph.visit_vertex(graph, "start"), "start", [["start"]], puzzle)
  end

  def explore(graph, current_vertex, paths, puzzle \\ :puzzle1) do
    unvisited =
      Graph.neighbors(graph, current_vertex)
      |> Enum.filter(fn vertex -> can_visit?(graph, vertex, puzzle) end)

    case length(unvisited) do
      0 -> paths
      _ -> Enum.flat_map(unvisited, fn vertex -> visit(graph, paths, vertex, puzzle) end)
    end
  end

  def visit(graph, [current_path | paths], vertex, puzzle \\ :puzzle1) do
    paths = [[vertex | current_path] | paths]

    case is_end?(vertex) do
      true -> paths
      false -> explore(Graph.visit_vertex(graph, vertex), vertex, paths, puzzle)
    end
  end

  def can_visit?(graph, vertex, :puzzle1) do
    cond do
      is_start?(vertex) -> false
      is_big?(vertex) -> true
      true -> graph.vertices[vertex] < 1
    end
  end

  def can_visit?(graph, vertex, :puzzle2) do
    cond do
      is_start?(vertex) ->
        false

      is_big?(vertex) ->
        true

      Enum.any?(graph.vertices, fn {v, visits} -> !is_big?(v) and visits > 1 end) ->
        graph.vertices[vertex] < 1

      true ->
        graph.vertices[vertex] < 2
    end
  end

  def is_start?(vertex), do: vertex == "start"
  def is_end?(vertex), do: vertex == "end"
  def is_big?(vertex), do: String.match?(vertex, ~r/[A-Z]+/)
end
