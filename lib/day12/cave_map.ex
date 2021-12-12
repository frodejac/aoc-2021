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
    unvisited = Graph.neighbors(graph, current_vertex)
                |> Enum.filter(fn vertex -> Graph.can_visit?(graph, vertex, puzzle) end)

    case length(unvisited) do
      0 -> paths
      _ -> Enum.flat_map(unvisited, fn vertex -> visit(graph, paths, vertex, puzzle) end)
    end
  end

  def visit(graph, [current_path | paths], vertex, puzzle \\ :puzzle1) do
    paths = [[vertex | current_path] | paths]

    case Graph.Vertex.is_end?(vertex) do
      true -> paths
      false -> explore(Graph.visit_vertex(graph, vertex), vertex, paths, puzzle)
    end
  end
end
