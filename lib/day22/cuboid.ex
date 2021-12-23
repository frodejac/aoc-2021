defmodule Day22.Reactor do
  alias Day22.Instruction, as: Instruction

  def startup(instructions) do
    perform_instruction(instructions, [])
  end

  def perform_instruction([], cuboids), do: cuboids

  def perform_instruction([instruction = %Instruction{state: 0} | tail], cuboids) do
    # Turn off
    perform_instruction(tail, remove_volume(cuboids, cuboid(instruction)))
  end

  def perform_instruction([instruction = %Instruction{state: 1} | tail], cuboids) do
    # Turn on
    new_cuboid = cuboid(instruction)
    perform_instruction(tail, [new_cuboid | remove_volume(cuboids, new_cuboid)])
  end

  def cuboid(instruction = %Instruction{}) do
    {instruction.x, instruction.y, instruction.z}
  end

  def disjoint?(cuboid1, cuboid2) when is_tuple(cuboid1) and is_tuple(cuboid2) do
    disjoint?(Tuple.to_list(cuboid1), Tuple.to_list(cuboid2))
  end

  def disjoint?(cuboid1, cuboid2) when is_list(cuboid1) and is_list(cuboid2) do
    Enum.zip(cuboid1, cuboid2)
    |> Enum.all?(fn {a, b} -> Range.disjoint?(a, b) end)
  end

  def remove_volume(cuboids, cuboid) when is_list(cuboids) and is_tuple(cuboid) do
    Enum.flat_map(cuboids, fn cub ->
      if disjoint?(cub, cuboid), do: [cub], else: remove_volume(cub, cuboid)
    end)
  end

  def remove_volume(cuboid1, cuboid2) when is_tuple(cuboid1) and is_tuple(cuboid2) do
    remove_volume(Tuple.to_list(cuboid1), Tuple.to_list(cuboid2))
    |> Enum.map(&List.to_tuple/1)
  end

  def remove_volume([range1 | tail1], [range2 | tail2]) do
    disjoin(range1, range2)
    |> Enum.flat_map(fn range ->
      if Range.disjoint?(range, range2) do
        [[range | tail1]]
      else
        for chunk <- remove_volume(tail1, tail2), do: [range | chunk]
      end
    end)
  end

  def remove_volume([], []), do: []

  def disjoin(i..j, k.._) when k > j, do: [i..j]
  def disjoin(i..j, k..l) when k > i and l >= j, do: [i..(k - 1), k..j]
  def disjoin(i..j, k..l) when k > i and l < j, do: [i..(k - 1), k..l, (l + 1)..j]
  def disjoin(i..j, _..l) when l >= i and l < j, do: [i..l, (l + 1)..j]
  def disjoin(i..j, _), do: [i..j]
end
