defmodule Day4 do
  @moduledoc false

  def setup_board(input) do
    board = Enum.map(input, &String.trim/1)
            |> Enum.map(&String.split(&1, " "))
            |> Enum.map(
                 fn row -> Enum.filter(row, fn x -> x != "" end)
                           |> Enum.map(&String.to_integer(&1, 10))
                           |> Enum.with_index
                 end
               )
            |> Enum.with_index
            |> Enum.reduce(
                 %{},
                 fn {row_data, row_idx}, acc ->
                   Enum.reduce(
                     row_data,
                     %{},
                     fn {col_data, col_idx}, acc -> Map.put(acc, {row_idx, col_idx}, col_data) end
                   )
                   |> Enum.into(acc)
                 end
               )
    match = Enum.reduce(board, %{}, fn {key, _}, acc -> Map.put(acc, key, 0)end)
    %{board: board, match: match}
  end

  def mark_number(number, boards), do: Enum.map(boards, &mark_number(number, &1.board, &1.match))

  def mark_number(number, board, match) do
    match = for {key, value} <- board, into: %{} do
      case value do
        ^number -> {key, 1}
        _ -> {key, Map.get(match, key)}
      end
    end
    %{board: board, match: match}
  end

  def check(boards) when is_list(boards) do
    Enum.map(boards, &check(&1))
    |> Enum.filter(
         fn
           {_, %{completed: true}} -> true
           {_, %{}} -> false
         end
       )
  end

  def check(board) when is_map(board) do
    completed = for {{row_idx, col_idx}, 1} <- board.match, reduce: %{} do
                  acc ->
                    Map.update(acc, {:row, row_idx}, 1, &(&1 + 1))
                    |> Map.update({:col, col_idx}, 1, &(&1 + 1))
                end
                |> Enum.filter(fn {_, count} -> count == 5 end)
                |> Enum.map(
                     fn {{type, idx}, _} -> case type do
                                              :row -> %{completed: true, row: idx, col: nil}
                                              :col -> %{completed: true, row: nil, col: idx}
                                            end
                     end
                   )
    case length(completed) do
      0 -> {board, %{completed: false, row: nil, col: nil}}
      1 -> {board, Enum.at(completed, 0)}
      _ -> raise "Completed more than one column or row"
    end
  end

  def bingo(boards, [head | tail]), do: bingo(boards, head, tail)

  def bingo(boards, number, []) do
    marked_boards = mark_number(number, boards)
    case check(marked_boards) do
      [] -> nil
      [{board, completed_info}] -> {board, completed_info, number}
    end
  end

  def bingo(boards, number, [head | tail]) do
    marked_boards = mark_number(number, boards)
    case check(marked_boards) do
      [] -> bingo(marked_boards, head, tail)
      [{board, completed_info}] -> {board, completed_info, number}
    end
  end


  def puzzle1 do
    {numbers, boards} = File.stream!("./input/day4/input1.txt")
                        |> Enum.split(1)

    boards = Enum.chunk_by(boards, fn string -> string == "\n" end)
             |> Enum.filter(fn list -> Enum.at(list, 0) != "\n" end)
             |> Enum.map(&setup_board/1)

    numbers = Enum.map(numbers, &String.trim/1)
              |> Enum.at(0)
              |> String.split(",")
              |> Enum.map(&String.to_integer(&1, 10))

    {board, completed_info, winning_number} = bingo(boards, numbers)
    sum_unmarked = for {key, 0} <- board.match, reduce: 0 do
      acc -> acc + Map.get(board.board, key)
    end
    sum_unmarked * winning_number
  end

end
