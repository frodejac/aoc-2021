defmodule Cucumber do
  defstruct [:map, :max_x, :max_y]

  def new(map) do
    {{max_x, max_y}, _} = Enum.max(map)

    %Cucumber{
      map:
        Enum.reduce(
          map,
          map,
          fn {k, _}, acc ->
            Map.update!(
              acc,
              k,
              fn
                "v" -> :south
                ">" -> :east
                "." -> :empty
              end
            )
          end
        ),
      max_x: max_x,
      max_y: max_y
    }
  end

  def can_move?(cucumbers, {{x, y}, :south}) do
    Map.get(cucumbers.map, {x, rem(y + 1, cucumbers.max_y + 1)}) == :empty
  end

  def can_move?(cucumbers, {{x, y}, :east}) do
    Map.get(cucumbers.map, {rem(x + 1, cucumbers.max_x + 1), y}) == :empty
  end

  def move({{x, y}, :south}, cucumbers) do
    map = Map.put(cucumbers.map, {x, rem(y + 1, cucumbers.max_y + 1)}, :south)
    map = Map.put(map, {x, y}, :empty)
    %Cucumber{cucumbers | map: map}
  end

  def move({{x, y}, :east}, cucumbers) do
    map = Map.put(cucumbers.map, {rem(x + 1, cucumbers.max_x + 1), y}, :east)
    map = Map.put(map, {x, y}, :empty)
    %Cucumber{cucumbers | map: map}
  end

  def move([], cucumbers), do: cucumbers

  def move([head | tail], cucumbers) do
    move(tail, move(head, cucumbers))
  end

  def move(cucumbers, direction) do
    cucumbers.map
    |> Enum.filter(fn
      {_, ^direction} -> true
      _ -> false
    end)
    |> Enum.filter(&can_move?(cucumbers, &1))
    |> move(cucumbers)
  end

  def run(cucumbers) do
    run(cucumbers, 0)
  end

  def run(cucumbers, step) do
    next = step(cucumbers)

    if cucumbers == next do
      step + 1
    else
      run(next, step + 1)
    end
  end

  def step(cucumbers) do
    move(move(cucumbers, :east), :south)
  end

  def inspect(cucumbers) do
    for y <- 0..cucumbers.max_y, x <- 0..(cucumbers.max_x + 1) do
      if x == cucumbers.max_x + 1 do
        "\n"
      else
        case Map.get(cucumbers.map, {x, y}) do
          :south -> "v"
          :east -> ">"
          :empty -> "."
        end
      end
    end
    |> Enum.reduce("", fn s, acc -> acc <> s end)
    |> IO.puts()

    cucumbers
  end
end
