defmodule Helpers.IO do
  def stream_trimmed_lines(filepath) do
    File.stream!(filepath)
    |> Stream.map(&String.trim/1)
  end

  def stream_list_of_graphemes(filepath) do
    stream_trimmed_lines(filepath)
    |> Stream.map(&String.graphemes/1)
  end

  def stream_list_of_integers(filepath) do
    stream_list_of_graphemes(filepath)
    |> Stream.map(&Enum.map(&1, fn s -> String.to_integer(s) end))
  end

  def read_as_2d_map(filepath) do
    stream_list_of_integers(filepath)
    |> Stream.map(&Enum.with_index/1)
    |> Stream.with_index()
    |> Enum.flat_map(fn {list, y_idx} ->
      Enum.reduce(list, [], fn {value, x_idx}, acc ->
        List.insert_at(acc, -1, {{x_idx, y_idx}, value})
      end)
    end)
    |> Enum.reduce(%{}, fn {{x, y}, value}, acc -> Map.put(acc, {x, y}, value) end)
  end

  def read_lines_as_integers(filepath, base \\ 10) do
    stream_trimmed_lines(filepath)
    |> Enum.map(&String.to_integer(&1, base))
  end
end
