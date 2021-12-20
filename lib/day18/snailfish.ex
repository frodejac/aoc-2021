defmodule Day18.Snailfish.Number do
  defstruct [:left, :right, :depth, :parent]

  alias Day18.Snailfish.Number, as: Number

  def new(string) do
    String.graphemes(string)
    |> parse(nil, 0)
  end

  def add(left, right) do
    %Number{
      left: increase_depth(left),
      right: increase_depth(right),
      depth: 0
    }
  end

  def increase_depth(number) when is_number(number), do: number

  def increase_depth(number) do
    %Number{
      left: increase_depth(number.left),
      right: increase_depth(number.right),
      depth: number.depth + 1
    }
  end

  def reduce(number) do
    cond do
      should_explode?(number) ->
        reduce(explode(number))

      should_split?(number) ->
        {_, number} = split(number)
        reduce(number)

      true ->
        number
    end
  end

  def traverse(number, check) when is_map(number) do
    if check.(number) do
      true
    else
      if traverse(number.left, check) do
        true
      else
        traverse(number.right, check)
      end
    end
  end

  def traverse(number, check) when is_number(number) do
    check.(number)
  end

  def explode?(number) when is_map(number), do: number.depth >= 4
  def explode?(_), do: false
  def should_explode?(number), do: traverse(number, &explode?/1)

  def update_exploded_right(number, right_val) when is_number(number), do: number + right_val

  def update_exploded_right(number, right_val) do
    # Update first regular number on the left
    %Number{number | left: update_exploded_right(number.left, right_val)}
  end

  def update_exploded_left(number, left_val) when is_number(number), do: number + left_val

  def update_exploded_left(number, left_val) do
    # Update first regular number on the right
    %Number{number | right: update_exploded_left(number.right, left_val)}
  end

  def explode(number) do
    {_, _, _, number} = explode(number, nil, nil, :continue)
    number
  end

  def explode(number, left_val, right_val, status) when is_number(number) do
    {status, left_val, right_val, number}
  end

  def explode(number, _, _, status) when is_map(number) and number.depth == 4 do
    if status == :exploded do
      raise "Hello"
    end

    {:exploded, number.left, number.right, 0}
  end

  def explode(number, left_val, right_val, status) do
    # Left branch
    {status, left_val, right_val, left} = explode(number.left, left_val, right_val, status)
    number = %Number{number | left: left}

    # If left branch exploded, update right branch (unless already done)
    {number, right_val} =
      if status == :exploded and right_val != :updated do
        {%Number{number | right: update_exploded_right(number.right, right_val)}, :updated}
      else
        {number, right_val}
      end

    # If left branch didn't explode, explode right branch
    if status != :exploded do
      {status, left_val, right_val, right} = explode(number.right, left_val, right_val, status)
      number = %Number{number | right: right}

      {number, left_val} =
        if status == :exploded and left_val != :updated do
          {%Number{number | left: update_exploded_left(number.left, left_val)}, :updated}
        else
          {number, left_val}
        end

      {status, left_val, right_val, number}
    else
      {status, left_val, right_val, number}
    end
  end

  def split?(number) when is_number(number), do: number >= 10
  def split?(_), do: false
  def should_split?(number), do: traverse(number, &split?/1)

  def split(number) when is_map(number) do
    result =
      case split(number.left) do
        {:continue, _} ->
          split(number.right)

        {:stop, left} ->
          {
            :stopleft,
            %Number{
              number
              | left: %{
                  left
                  | depth: number.depth + 1
                }
            }
          }
      end

    case result do
      {:continue, _} ->
        {:continue, number}

      {:stopleft, number} ->
        {:stop, number}

      {:stop, right} ->
        {
          :stop,
          %Number{
            number
            | right: %Number{
                right
                | depth: number.depth + 1
              }
          }
        }
    end
  end

  def split(number) when is_number(number) do
    case split?(number) do
      true -> {:stop, %Number{left: floor(number / 2), right: ceil(number / 2)}}
      false -> {:continue, number}
    end
  end

  def magnitude(number) do
    left =
      cond do
        is_map(number.left) -> magnitude(number.left)
        true -> number.left
      end

    right =
      cond do
        is_map(number.right) -> magnitude(number.right)
        true -> number.right
      end

    3 * left + 2 * right
  end

  def parse([], node, _) do
    node
  end

  def parse(tokens, node, depth) do
    [token | tail] = tokens

    case token do
      "[" -> parse(tail, child(node, depth), depth + 1)
      "," -> parse(tail, node, depth)
      "]" -> parse(tail, parent(node), depth - 1)
      s -> parse(tail, set_value(node, String.to_integer(s)), depth)
    end
  end

  def parent(node) do
    case node.parent do
      nil -> node
      parent -> set_value(parent, %Number{node | parent: nil})
    end
  end

  def child(node, depth) do
    %Number{parent: node, depth: depth}
  end

  def set_value(node, value) do
    if node.left == nil do
      %Number{node | left: value}
    else
      %Number{node | right: value}
    end
  end

  def print(number) do
    IO.puts(build_string(number))
  end

  def build_string(number) when is_map(number) do
    "[" <> build_string(number.left) <> "," <> build_string(number.right) <> "]"
  end

  def build_string(number) when is_number(number), do: Integer.to_string(number)
end
