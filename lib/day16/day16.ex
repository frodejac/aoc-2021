defmodule Day16 do
  def get_input do
    hexstring = File.read!("./input/day16/input.txt")

    hexstring
    |> String.to_integer(16)
    |> Integer.to_string(2)
    |> String.pad_leading(String.length(hexstring) * 4, "0")
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
  end

  def puzzle1 do
    get_input()
    |> BITS.parse()
    |> elem(0)
    |> BITS.AST.version_sum()
  end

  def puzzle2 do
    get_input()
    |> BITS.parse()
    |> elem(0)
    |> BITS.AST.evaluate()
  end
end
