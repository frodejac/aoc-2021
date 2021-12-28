defmodule Day24.Solver do
  def new(input) do
    String.split(input, "inp w\n", trim: true)
    |> Enum.map(&parse_block/1)
    |> find_constraint_pairs()
  end

  def parse_block(block) do
    lines = String.split(block, "\n", trim: true)

    x_add =
      Enum.at(lines, 4)
      |> then(&Regex.run(~r/-?[0-9]+/, &1))
      |> List.first()
      |> String.to_integer()

    y_add =
      Enum.at(lines, -3)
      |> then(&Regex.run(~r/-?[0-9]+/, &1))
      |> List.first()
      |> String.to_integer()

    {x_add, y_add}
  end

  def find_constraint_pairs(parsed_blocks) do
    find_constraint_pairs(Enum.with_index(parsed_blocks), [], [])
  end

  def find_constraint_pairs([], [], result), do: result

  def find_constraint_pairs([{{x_add, y_add}, idx} | tail], stack, result) do
    if x_add >= 0 do
      find_constraint_pairs(tail, [{{x_add, y_add}, idx} | stack], result)
    else
      [{{_, stack_y_add}, stack_idx} | stack] = stack
      find_constraint_pairs(tail, stack, [{idx, stack_idx, x_add + stack_y_add} | result])
    end
  end

  def resolve_constraints(constraints, mode) do
    constraints
    |> Enum.map(&resolve_constraint(&1, mode))
    |> Enum.reduce(%{}, fn result, acc -> Map.merge(acc, result) end)
    |> Map.to_list()
    |> Enum.reduce("", fn {_, i}, acc -> acc <> Integer.to_string(i) end)
    |> String.to_integer()
  end

  def resolve_constraint({a, b, constraint}, :high) when constraint > 0 do
    %{a => 9, b => 9 - constraint}
  end

  def resolve_constraint({a, b, constraint}, :high) when constraint < 0 do
    %{a => 9 - abs(constraint), b => 9}
  end

  def resolve_constraint({a, b, constraint}, :high) when constraint == 0 do
    %{a => 9, b => 9}
  end

  def resolve_constraint({a, b, constraint}, :low) when constraint > 0 do
    %{a => 1 + constraint, b => 1}
  end

  def resolve_constraint({a, b, constraint}, :low) when constraint < 0 do
    %{a => 1, b => 1 + abs(constraint)}
  end

  def resolve_constraint({a, b, constraint}, :low) when constraint == 0 do
    %{a => 1, b => 1}
  end
end
