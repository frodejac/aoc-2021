defmodule Graph.Dijkstra do
  def dijkstra(graph, source, target) do
    costs = Enum.reduce(graph, %{}, fn {k, _}, acc -> Map.put(acc, k, :infinity) end)
    dijkstra([{source, 0}], graph, target, costs)
  end

  def dijkstra([{node, cost} | _], _, target, _) when node == target do
    cost
  end

  def dijkstra([{node, cost} | queue], graph, target, costs) do
    {queue, costs} =
      Helpers.Geometry.neighbors(node, :fourway)
      |> Enum.reduce(
        {queue, costs},
        fn neighbor, {queue_acc, costs_acc} ->
          update(neighbor, cost, graph[neighbor], queue_acc, costs_acc)
        end
      )

    dijkstra(Enum.sort(queue), graph, target, costs)
  end

  def update(_, _, nil, queue, costs) do
    {queue, costs}
  end

  def update(vertex, vertex_cost, current_cost, queue, costs) do
    new_cost = current_cost + vertex_cost

    if new_cost < costs[vertex] do
      {[{vertex, new_cost} | queue], Map.put(costs, vertex, new_cost)}
    else
      {queue, costs}
    end
  end
end
