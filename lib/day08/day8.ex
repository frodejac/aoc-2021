defmodule Day08 do

  alias Day08.Decoder, as: Decoder

  def parse_line(line) do
    line
    |> String.split("|", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
    |> Enum.with_index
    |> Enum.reduce(
         %{},
         fn {data, idx}, acc ->
           case idx do
             0 -> Map.put(acc, :input, data)
             1 -> Map.put(acc, :output, data)
           end
         end
       )
  end

  def get_input() do
    File.stream!("./input/day08/input.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
    |> Enum.to_list
  end

  def puzzle1 do
    get_input()
    |> Decoder.decode(:puzzle1)
    |> Enum.filter(fn s -> s != nil end)
    |> length
  end

  def puzzle2 do
    get_input()
    |> Enum.map(&Decoder.decipher_and_decode(&1.input, &1.output))
    |> Enum.reduce(0, fn num, acc -> acc + num end)
  end

end
