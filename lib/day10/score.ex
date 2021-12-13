defmodule Day10.Score do
  def score(errors, :puzzle1) when is_list(errors) do
    errors
    |> Enum.map(&score(&1, :puzzle1))
    |> Enum.sum()
  end

  def score(char, :puzzle1) do
    case char do
      ")" -> 3
      "]" -> 57
      "}" -> 1197
      ">" -> 25137
    end
  end

  def score(added, :puzzle2) when is_list(added) do
    added
    |> Enum.map(&score_line(&1, :puzzle2))
    |> Enum.sort()
    |> (&Enum.at(&1, floor(length(&1) / 2))).()
  end

  def score(char, :puzzle2) do
    case char do
      ")" -> 1
      "]" -> 2
      "}" -> 3
      ">" -> 4
    end
  end

  def score_line(added, :puzzle2) do
    Enum.reduce(added, 0, fn char, acc -> acc * 5 + score(char, :puzzle2) end)
  end
end
