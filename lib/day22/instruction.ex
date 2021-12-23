defmodule Day22.Instruction do
  defstruct [:state, :x, :y, :z]

  def new(string) do
    [state, ranges] = String.split(string, " ")

    state =
      case state do
        "on" -> 1
        "off" -> 0
      end

    [{x0, x1}, {y0, y1}, {z0, z1}] =
      String.split(ranges, ",")
      |> Enum.map(&String.replace(&1, ~r/[xyz]=/, ""))
      |> Enum.map(
        &(String.split(&1, "..")
          |> Enum.map(fn s -> String.to_integer(s) end)
          |> List.to_tuple())
      )

    %Day22.Instruction{state: state, x: x0..x1, y: y0..y1, z: z0..z1}
  end

  def inside?(instruction, bbox) do
    [instruction.x, instruction.y, instruction.z]
    |> Enum.all?(fn a..b -> a >= -50 and b <= 50 end)
  end
end
