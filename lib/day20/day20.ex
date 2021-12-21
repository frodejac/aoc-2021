defmodule Day20 do
  def get_input() do
    [enhance_alg, image] =
      File.read!("./input/day20/input.txt")
      |> String.split("\n\n")

    enhance_alg =
      String.split(enhance_alg, "", trim: true)
      |> Enum.map(fn s ->
        case s do
          "#" -> 1
          "." -> 0
        end
      end)

    image =
      String.split(image, "\n", trim: true)
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(
        &Enum.map(
          &1,
          fn s ->
            case s do
              "#" -> 1
              "." -> 0
            end
          end
        )
      )
      |> Enum.map(&Enum.with_index/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {list, y_idx} ->
        Enum.reduce(
          list,
          [],
          fn {value, x_idx}, acc ->
            List.insert_at(acc, -1, {{x_idx, y_idx}, value})
          end
        )
      end)
      |> Enum.reduce(%{}, fn {{x, y}, value}, acc -> Map.put(acc, {x, y}, value) end)

    {enhance_alg, image}
  end

  def puzzle1() do
    {enhance_alg, image} = get_input()

    Image.enhance(%Image{pixels: image, pad: Enum.at(enhance_alg, 0)}, enhance_alg, 2)
    |> Map.get(:pixels)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end

  def puzzle2() do
    {enhance_alg, image} = get_input()

    Image.enhance(%Image{pixels: image, pad: Enum.at(enhance_alg, 0)}, enhance_alg, 50)
    |> Map.get(:pixels)
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.sum()
  end
end
