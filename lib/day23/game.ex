defmodule Day23.AmphipodGame do
  @hallway [0, 1, 3, 5, 7, 9, 10]
  @rooms [2, 4, 6, 8]
  @hallway_positions for i <- @hallway, do: {{i, 0}, :empty}

  def new(rooms) do
    rooms =
      rooms
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, slot} ->
        Enum.reduce(row, [], fn {pod, room}, acc -> [{{(room + 1) * 2, slot + 1}, pod} | acc] end)
      end)
      |> Map.new()
      |> Enum.reduce(
        %{},
        fn
          {key, 0}, acc -> Map.put(acc, key, :amber)
          {key, 1}, acc -> Map.put(acc, key, :bronze)
          {key, 2}, acc -> Map.put(acc, key, :copper)
          {key, 3}, acc -> Map.put(acc, key, :desert)
        end
      )

    game =
      Enum.concat(rooms, @hallway_positions)
      |> Map.new()

    {{_, room_depth}, _} = Enum.max_by(game, fn {{_, slot}, _} -> slot end)
    Process.put(:roomdepth, room_depth)
    game
  end

  def room(pod) do
    case pod do
      :amber -> 2
      :bronze -> 4
      :copper -> 6
      :desert -> 8
      :empty -> nil
    end
  end

  def weight(pod) do
    case pod do
      :amber -> 1
      :bronze -> 10
      :copper -> 100
      :desert -> 1000
    end
  end

  def distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def movecost(from, to, pod), do: distance(from, to) * weight(pod)

  def solved?(game) do
    Enum.all?(
      game,
      fn
        {{_, 0}, pod} -> pod == :empty
        {{room, _}, pod} -> room == room(pod)
      end
    )
  end

  def solved?(_, {{_, 0}, _}), do: false

  def solved?(game, {{x, y}, pod}),
    do: room(pod) == x and Enum.all?(y..Process.get(:roomdepth, 2), &(game[{x, &1}] == pod))

  def path({hallway, 0}, {room, slot}),
    do: for(x <- hallway..room, do: {x, 0}) ++ for(y <- 0..slot, do: {room, y})

  def path({room, slot}, {hallway, 0}),
    do: for(x <- room..hallway, do: {x, 0}) ++ for(y <- slot..0, do: {room, y})

  def clear_path?(game, from, to) do
    path(from, to)
    |> List.delete(from)
    |> MapSet.new()
    |> Enum.map(&Map.get(game, &1, :empty))
    |> Enum.all?(&(&1 == :empty))
  end

  def target(game, pod),
    do: {room(pod), Enum.find(Process.get(:roomdepth, 2)..1, &(game[{room(pod), &1}] != pod))}

  def misplaced_pods(game) do
    hallway_pods =
      game
      # Only consider hallway
      |> Enum.filter(fn {{_, y}, _} -> y == 0 end)
      # Reject empty
      |> Enum.reject(fn {_, pod} -> pod == :empty end)

    room_pods =
      game
      # Reject hallway pods
      |> Enum.reject(fn {{_, y}, _} -> y == 0 end)
      # Reject empty
      |> Enum.reject(fn {_, pod} -> pod == :empty end)
      # Reject solved pods
      |> Enum.reject(&solved?(game, &1))

    {hallway_pods, room_pods}
  end

  def legal_moves(game) do
    {hallway_pods, room_pods} = misplaced_pods(game)

    hallway_moves =
      Enum.map(hallway_pods, fn {position, pod} -> {position, target(game, pod), pod} end)

    room_moves =
      Enum.flat_map(room_pods, fn {position, pod} ->
        Enum.map(@hallway_positions, &{position, elem(&1, 0), pod})
      end)

    Enum.concat(hallway_moves, room_moves)
    |> Enum.filter(&clear_path?(game, elem(&1, 0), elem(&1, 1)))
  end

  def move(game, cost, {x1, y1}, {x2, y2}, pod) do
    game
    |> Map.put({x1, y1}, :empty)
    |> Map.put({x2, y2}, pod)
    |> then(&{&1, cost + movecost({x1, y1}, {x2, y2}, pod)})
  end

  def dijkstra([{game, cost} | queue]) do
    if solved?(game) do
      cost
    else
      queue =
        legal_moves(game)
        |> Enum.map(&move(game, cost, elem(&1, 0), elem(&1, 1), elem(&1, 2)))
        |> Enum.reduce(
          queue,
          fn {new_state, new_cost}, acc -> enqueue(acc, new_state, new_cost) end
        )
        |> Enum.sort(fn {_, cost1}, {_, cost2} -> cost1 < cost2 end)

      dijkstra(queue)
    end
  end

  def enqueue(queue, gamestate, cost) do
    if cost < Process.get(gamestate, :infinity) do
      Process.put(gamestate, cost)
      [{gamestate, cost} | queue]
    else
      queue
    end
  end

  def find_cheapest_solution(game) do
    dijkstra([{game, 0}])
  end
end
