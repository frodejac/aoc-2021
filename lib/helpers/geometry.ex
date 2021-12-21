defmodule Helpers.Geometry do
  def convkernel({x, y}) do
    upleft = {x - 1, y - 1}
    up = {x, y - 1}
    upright = {x + 1, y - 1}
    left = {x - 1, y}
    right = {x + 1, y}
    downleft = {x - 1, y + 1}
    down = {x, y + 1}
    downright = {x + 1, y + 1}
    [upleft, up, upright, left, {x, y}, right, downleft, down, downright]
  end

  def neighbors({x, y}) do
    up = {x, y + 1}
    upleft = {x - 1, y + 1}
    left = {x - 1, y}
    downleft = {x - 1, y - 1}
    down = {x, y - 1}
    downright = {x + 1, y - 1}
    right = {x + 1, y}
    upright = {x + 1, y + 1}
    [up, upleft, left, downleft, down, downright, right, upright]
  end

  def neighbors({x, y}, :fourway) do
    up = {x, y + 1}
    left = {x - 1, y}
    down = {x, y - 1}
    right = {x + 1, y}
    [up, left, down, right]
  end

  def manhattan_distance({x1, y1, z1}, {x2, y2, z2}) do
    abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
  end

  def translation({x1, y1, z1}, {x2, y2, z2}), do: {x1 - x2, y1 - y2, z1 - z2}

  def translate({x1, y1, z1}, {x2, y2, z2}), do: {x1 + x2, y1 + y2, z1 + z2}

  def rotate({x, y, z}, rotation) do
    for row <- rotation do
      Enum.zip(row, [x, y, z])
      |> Enum.map(&Enum.product(Tuple.to_list(&1)))
      |> Enum.sum()
    end
    |> List.to_tuple()
  end

  def rotations() do
    [
      [
        [1, 0, 0],
        [0, 1, 0],
        [0, 0, 1]
      ],
      [
        [-1, 0, 0],
        [0, -1, 0],
        [0, 0, 1]
      ],
      [
        [-1, 0, 0],
        [0, 1, 0],
        [0, 0, -1]
      ],
      [
        [1, 0, 0],
        [0, -1, 0],
        [0, 0, -1]
      ],
      [
        [0, 1, 0],
        [0, 0, 1],
        [1, 0, 0]
      ],
      [
        [0, -1, 0],
        [0, 0, 1],
        [-1, 0, 0]
      ],
      [
        [0, 1, 0],
        [0, 0, -1],
        [-1, 0, 0]
      ],
      [
        [0, -1, 0],
        [0, 0, -1],
        [1, 0, 0]
      ],
      [
        [0, 0, 1],
        [1, 0, 0],
        [0, 1, 0]
      ],
      [
        [0, 0, 1],
        [-1, 0, 0],
        [0, -1, 0]
      ],
      [
        [0, 0, -1],
        [-1, 0, 0],
        [0, 1, 0]
      ],
      [
        [0, 0, -1],
        [1, 0, 0],
        [0, -1, 0]
      ],
      [
        [0, 0, -1],
        [0, -1, 0],
        [-1, 0, 0]
      ],
      [
        [0, 0, 1],
        [0, 1, 0],
        [-1, 0, 0]
      ],
      [
        [0, 0, 1],
        [0, -1, 0],
        [1, 0, 0]
      ],
      [
        [0, 0, -1],
        [0, 1, 0],
        [1, 0, 0]
      ],
      [
        [0, -1, 0],
        [-1, 0, 0],
        [0, 0, -1]
      ],
      [
        [0, 1, 0],
        [-1, 0, 0],
        [0, 0, 1]
      ],
      [
        [0, -1, 0],
        [1, 0, 0],
        [0, 0, 1]
      ],
      [
        [0, 1, 0],
        [1, 0, 0],
        [0, 0, -1]
      ],
      [
        [-1, 0, 0],
        [0, 0, -1],
        [0, -1, 0]
      ],
      [
        [-1, 0, 0],
        [0, 0, 1],
        [0, 1, 0]
      ],
      [
        [1, 0, 0],
        [0, 0, 1],
        [0, -1, 0]
      ],
      [
        [1, 0, 0],
        [0, 0, -1],
        [0, 1, 0]
      ]
    ]
  end
end
