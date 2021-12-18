defmodule Day17.TrickShot do
  def grid_search_x(x_min, x_max) do
    generate_trajectories_x(x_max)
    |> Enum.filter(fn {_, trajectory} ->
      Enum.any?(trajectory, fn x -> x >= x_min and x <= x_max end)
    end)
  end

  def generate_trajectories_x(x_max) do
    # Create trajectory until outside bounding box for all reasonable initial velocities
    Enum.map(x_max..0, fn vel -> {vel, Enum.reverse(trajectory_x(vel, x_max))} end)
  end

  def trajectory_x(velocity, x_max) do
    step_x([0], velocity, x_max)
  end

  def step_x(positions, 0, _), do: positions

  def step_x(positions, velocity, x_max) do
    [pos | _] = positions
    step_x([pos + velocity | positions], max(velocity - 1, 0), x_max)
  end

  def grid_search_y(y_min, y_max) do
    generate_trajectories_y(y_min)
    |> Enum.filter(fn {_, trajectory} ->
      Enum.any?(trajectory, fn y -> y >= y_min and y <= y_max end)
    end)
  end

  def generate_trajectories_y(y_min) do
    Enum.map((-y_min - 1)..y_min, fn vel -> {vel, Enum.reverse(trajectory_y(vel, y_min))} end)
  end

  def trajectory_y(velocity, y_min) do
    step_y([0], velocity, y_min)
  end

  def step_y(positions, velocity, y_min) do
    [pos | tail] = positions

    cond do
      pos < y_min -> tail
      true -> step_y([pos + velocity | positions], velocity - 1, y_min)
    end
  end

  def inside?({x, y}, target) do
    x >= target[:x_min] and x <= target[:x_max] and y >= target[:y_min] and y <= target[:y_max]
  end
end
