defmodule Day08.Decoder do
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
    |> Enum.map(& &1.output)
    |> Enum.reduce([], fn line, acc -> Enum.concat(acc, line) end)
    |> Enum.map(&decode(&1, :puzzle1))
  end

  # ---------------- PUZZLE 2 --------------------

  defp string_to_mapset(string) do
    string
    |> String.to_charlist()
    |> MapSet.new()
  end

  defp decipher_unique(signal) do
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

  defp decode(output, signal_map, :puzzle2) do
    output
    |> Enum.map(&Map.get(signal_map, string_to_mapset(&1)))
    |> Enum.map(&Integer.to_string/1)
    |> Enum.join()
    |> String.to_integer()
  end

  def decipher_and_decode(signal, output) do
    # Initialize signal map with well-known values
    signal_map = decipher_unique(signal)
    # Filter out known values
    remaining_signal =
      Enum.filter(signal, fn s -> !(string_to_mapset(s) in Map.values(signal_map)) end)

    decipher_and_decode(remaining_signal, signal_map, output)
  end

  def decipher_and_decode(signal, signal_map, output) do
    # Fill out signal map
    Enum.reduce(signal, signal_map, fn s, acc -> decipher(s, acc) end)
    # Reverse signal map
    |> Enum.reduce(%{}, fn {number, charset}, acc -> Map.put(acc, charset, number) end)
    # Decode output
    |> (&decode(output, &1, :puzzle2)).()
  end

  defp decipher(string, signal_map) when is_binary(string) do
    # At this point, we should only have 5 or 6-length signals
    case String.length(string) do
      5 -> decipher(string, signal_map, 5)
      6 -> decipher(string, signal_map, 6)
    end
  end

  defp decipher(string, signal_map, 6) do
    # 6-length strings are one of {0, 6, 9}
    # - If all segments in 4 are present in the signal, it must be a 9
    # - If all segments in 7 are present in the signal, it must be a 0
    # - Otherwise, it's a 6

    charset = string_to_mapset(string)

    cond do
      MapSet.intersection(charset, Map.get(signal_map, 4)) == Map.get(signal_map, 4) ->
        Map.put(signal_map, 9, charset)

      MapSet.intersection(charset, Map.get(signal_map, 7)) == Map.get(signal_map, 7) ->
        Map.put(signal_map, 0, charset)

      true ->
        Map.put(signal_map, 6, charset)
    end
  end

  defp decipher(string, signal_map, 5) do
    # 5-length strings are one of {2, 3, 5}
    # - If all segments in 1 are present in the string, it must be a 3
    # - If 3 of the segments in 4 are present in the string, it must be a 5
    # - Otherwise, it's a 2
    charset = string_to_mapset(string)

    cond do
      MapSet.intersection(charset, Map.get(signal_map, 1)) == Map.get(signal_map, 1) ->
        Map.put(signal_map, 3, charset)

      MapSet.size(MapSet.intersection(charset, Map.get(signal_map, 4))) == 3 ->
        Map.put(signal_map, 5, charset)

      true ->
        Map.put(signal_map, 2, charset)
    end
  end
end
