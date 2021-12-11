defmodule Day04 do
  @moduledoc false

  alias Day04.Board, as: Board

  def bingo({boards, numbers}), do: bingo(boards, numbers)
  def bingo(boards, [head | tail]), do: bingo(boards, head, tail)

  def bingo(boards, number, []) do
    marked_boards = Enum.map(boards, &Board.mark(&1, number))
    case Enum.find(marked_boards, fn b -> Board.winning?(b) end) do
      nil -> nil
      winner -> {winner, number}
    end
  end

  def bingo(boards, number, [head | tail]) do
    marked_boards = Enum.map(boards, &Board.mark(&1, number))
    case Enum.find(marked_boards, fn b -> Board.winning?(b) end) do
      nil -> bingo(marked_boards, head, tail)
      winner -> {winner, number}
    end
  end

  def ognib({boards, numbers}), do: ognib(boards, numbers)
  def ognib(boards, [head | tail]), do: ognib(boards, head, tail)

  def ognib(boards, number, [head | tail]) do
    losers = Enum.map(boards, &Board.mark(&1, number))
             |> Enum.filter(fn b -> !Board.winning?(b) end)

    case length(losers) do
      0 -> {Board.mark(Enum.at(boards, 0), number), number}
      _ -> ognib(losers, head, tail)
    end
  end

  def setup do
    {numbers, boards} = File.stream!("./input/day04/input.txt")
                        |> Enum.split(1)

    numbers = Enum.map(numbers, &String.trim/1)
              |> Enum.at(0)
              |> String.split(",")
              |> Enum.map(&String.to_integer(&1, 10))

    boards = Enum.chunk_by(boards, fn string -> string == "\n" end)
              |> Enum.filter(fn list -> Enum.at(list, 0) != "\n" end)
              |> Enum.map(&Board.parse_board/1)


    {boards, numbers}
  end

  def puzzle1 do
    setup()
    |> bingo()
    |> Board.final_score()
  end

  def puzzle2 do
    setup()
    |> ognib()
    |> Board.final_score()
  end

end
