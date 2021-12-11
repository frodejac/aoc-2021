defmodule Day09.Extrema do

  def transpose(list) do
    list
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  def find_local_minima_2d(input) do
    local_minima_x = input
                     |> Enum.flat_map(&find_local_minima/1)
                     |> MapSet.new()
    local_minima_y = input
                     |> transpose()
                     |> Enum.flat_map(&find_local_minima/1)
                     |> MapSet.new()

    MapSet.intersection(local_minima_x, local_minima_y)
  end

  def find_local_minima([{{x, y}, value} | tail]) do
    find_local_minima({{x, y}, value}, tail, MapSet.new())
  end

  def find_local_minima({{x, y}, current_value}, [{{next_x, next_y}, next_value} | tail], minima) do
    # Left edge
    minima = cond do
      current_value < next_value -> MapSet.put(minima, {x, y})
      true -> minima
    end
    find_local_minima(current_value, {{next_x, next_y}, next_value}, tail, minima)
  end

  def find_local_minima(previous_value, {{x, y}, current_value}, [], minima) do
    # Right edge
    cond do
      previous_value > current_value -> MapSet.put(minima, {x, y})
      true -> minima
    end
  end

  def find_local_minima(previous_value, {{x, y}, current_value}, [{{next_x, next_y}, next_value} | tail], minima) do
    minima = cond do
      local_minima?(previous_value, current_value, next_value) -> MapSet.put(minima, {x, y})
      true -> minima
    end
    find_local_minima(current_value, {{next_x, next_y}, next_value}, tail, minima)
  end


  def local_minima?(previous, current, next), do: current < previous and current < next


end
