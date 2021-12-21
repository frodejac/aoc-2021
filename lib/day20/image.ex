defmodule Image do
  defstruct [:pixels, :pad]

  def pad(image, value) do
    {{{min_x, min_y}, _}, {{max_x, max_y}, _}} = Enum.min_max(image)
    {min_x, min_y, max_x, max_y} = {min_x - 1, min_y - 1, max_x + 1, max_y + 1}

    image =
      Enum.reduce(
        min_x..max_x,
        image,
        fn x, acc ->
          Map.put(acc, {x, min_y}, value)
          |> Map.put({x, max_y}, value)
        end
      )

    Enum.reduce(
      min_y..max_y,
      image,
      fn y, acc ->
        Map.put(acc, {min_x, y}, value)
        |> Map.put({max_x, y}, value)
      end
    )
  end

  def convolve(image, algorithm) do
    pad_value = Enum.at(algorithm, image.pad * -1)
    padded_image = pad(image.pixels, pad_value)
    {{{min_x, min_y}, _}, {{max_x, max_y}, _}} = Enum.min_max(padded_image)

    new_pixels =
      for x <- min_x..max_x, y <- min_y..max_y do
        idx =
          for {i, j} <- Helpers.Geometry.convkernel({x, y}) do
            Map.get(padded_image, {i, j}, pad_value)
          end
          |> Integer.undigits(2)

        {{x, y}, Enum.at(algorithm, idx)}
      end
      |> Map.new()

    %Image{pixels: new_pixels, pad: pad_value}
  end

  def enhance(image, _, 0), do: image

  def enhance(image, algorithm, n) do
    enhance(convolve(image, algorithm), algorithm, n - 1)
  end

  def print(image) do
    image = image.pixels
    {{{min_x, min_y}, _}, {{max_x, max_y}, _}} = Enum.min_max(image)

    for y <- min_y..max_y, x <- min_x..(max_x + 1) do
      if x == max_x + 1 do
        "\n"
      else
        case Map.get(image, {x, y}) do
          0 -> "."
          1 -> "#"
        end
      end
    end
    |> Enum.reduce("", fn s, acc -> acc <> s end)
  end
end
