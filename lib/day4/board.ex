defmodule Day4.Board do
  def parse_board(string) do
    string
    |> Enum.map(&String.trim/1)
    |> Enum.flat_map(&String.split(&1, " ", trim: true))
    |> Enum.map(fn s -> {String.to_integer(s), false} end)
  end

  def mark(board, number) do
    List.keyreplace(board, number, 0, {number, true})
  end

  def get_marked_indices(board) do
    board
    |> Enum.with_index
    |> Enum.reduce(
         [],
         fn
           {{_, true}, idx}, acc -> [idx | acc]
           {{_, false}, _}, acc -> acc
         end
       )
    |> MapSet.new
  end

  def winning?(board) do
    marked_indices = get_marked_indices(board)
    Enum.any?(row_col_indices, fn row_or_col -> MapSet.intersection(row_or_col, marked_indices) == row_or_col end)
  end

  def final_score({board, winning_number}), do: final_score(board, winning_number)
  def final_score(board, winning_number) do
    board
    |> Enum.reduce(
         0,
         fn
           {num, false}, acc -> acc + num
           _, acc -> acc
         end
       )
    |> (&(&1 * winning_number)).()
  end

  def row_indices do
    for col <- 0..4, row <- 0..4 do
      row + 5 * col end
    |> Enum.chunk_every(5)
  end

  def col_indices do
    for col <- 0..4, row <- 0..4 do
      col + 5 * row end
    |> Enum.chunk_every(5)
  end

  def row_col_indices do
    (row_indices ++ col_indices)
    |> Enum.map(&MapSet.new/1)
  end



end
