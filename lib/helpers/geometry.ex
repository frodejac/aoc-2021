defmodule Helpers.Geometry do
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
end
