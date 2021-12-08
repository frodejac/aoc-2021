defmodule Day8.Decoder do

  def decode(string, :puzzle1) when is_binary(string) do
    case String.length(string) do
      2 -> 1
      3 -> 7
      4 -> 4
      7 -> 8
      _ -> nil
    end
  end

  def decode(data, :puzzle1) do
    data
    |> Enum.map(&(&1.output))
    |> Enum.reduce([], fn line, acc -> Enum.concat(acc, line) end)
    |> Enum.map(&decode(&1, :puzzle1))
  end


  # ---------------- PUZZLE 2 --------------------

  def string_to_mapset(string) do
    string
    |> String.to_charlist
    |> MapSet.new
  end

  def decipher_unique(signal) do
    Enum.reduce(
      signal,
      %{},
      fn s, acc ->
        case String.length(s) do
          2 -> Map.put(acc, 1, string_to_mapset(s))
          3 -> Map.put(acc, 7, string_to_mapset(s))
          4 -> Map.put(acc, 4, string_to_mapset(s))
          7 -> Map.put(acc, 8, string_to_mapset(s))
          _ -> acc
        end
      end
    )
  end

  def decode(output, signal_map) do
    output
    |> Enum.map(&Map.get(signal_map, string_to_mapset(&1)))
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
    |> String.to_integer
  end

  def decipher(signal, output) when is_list(signal) do
    # Initialize signal map with well-known values
    signal_map = decipher_unique(signal)
    remaining_signal = Enum.filter(signal, fn s -> !(string_to_mapset(s) in Map.values(signal_map)) end)
    decipher(remaining_signal, signal_map, output)
  end

  def decipher(string, signal_map) when is_binary(string) do
    case String.length(string) do
      6 -> decipher(string, signal_map, 6)
      5 -> decipher(string, signal_map, 5)
      _ -> signal_map
    end
  end

  def decipher(signal, signal_map, output) when is_list(signal) and length(signal) == 0 do
    # Reverse the signal map and decode output
    signal_map
    |> Enum.reduce(%{}, fn {number, charset}, acc -> Map.put(acc, charset, number) end)
    |> (&decode(output, &1)).()
  end

  def decipher(signal, signal_map, output) when is_list(signal) do
    signal_map = Enum.reduce(signal, signal_map, fn s, acc -> decipher(s, acc) end)
    remaining_signal = Enum.filter(signal, fn s -> !(string_to_mapset(s) in Map.values(signal_map)) end)
    decipher(remaining_signal, signal_map, output)
  end

  def decipher(string, signal_map, 6) do
    # 6-length digits are 0, 6, 9
    # If all segments in 4 are present in the signal, it must be a 9
    # If all segments in 7 are present in the signal, it must be a 0
    # Otherwise, it's a 6

    charset = string_to_mapset(string)
    cond do
      MapSet.intersection(charset, Map.get(signal_map, 4)) == Map.get(signal_map, 4) -> Map.put(signal_map, 9, charset)
      MapSet.intersection(charset, Map.get(signal_map, 7)) == Map.get(signal_map, 7) -> Map.put(signal_map, 0, charset)
      true -> Map.put(signal_map, 6, charset)
    end
  end

  def decipher(string, signal_map, 5) do
    # 5-length digits are 2, 3, 5
    # If all segments in 1 are present in the string, it must be a 3
    # If 3 of the segments in 4 are present in the string, it must be a 5
    # Otherwise, it's a 2

    charset = string_to_mapset(string)
    cond do
      MapSet.intersection(charset, Map.get(signal_map, 1)) == Map.get(signal_map, 1) -> Map.put(signal_map, 3, charset)
      MapSet.size(MapSet.intersection(charset, Map.get(signal_map, 4))) == 3 -> Map.put(signal_map, 5, charset)
      true -> Map.put(signal_map, 2, charset)
    end
  end

end
