defmodule Day10 do

  alias Day10.Parse, as: Parse
  alias Day10.Score, as: Score

  def get_input() do
    File.stream!("./input/day10/input.txt")
    |> Stream.map(&String.trim/1)
    |> Enum.to_list
  end

  def puzzle1 do
    get_input()
    |> Enum.map(&Parse.parse/1)
    |> Enum.filter(
         fn
           {:error, _} -> true
           _ -> false
         end
       )
    |> Enum.map(fn {_, char} -> char end)
    |> Score.score(:puzzle1)
  end

  def puzzle2 do
    get_input()
    |> Enum.map(&Parse.parse/1)
    |> Enum.filter(
         fn
           {:ok, _} -> true
           _ -> false
         end
       )
    |> Enum.map(fn {_, stack} -> stack end)
    |> Enum.map(&Parse.autocomplete/1)
    |> Score.score(:puzzle2)
  end

end
