defmodule Day10.Parse do

  def parse(string) do
    parse(String.graphemes(string), :queue.new())
  end

  def parse([], stack) do
    {:ok, stack}
  end

  def parse([head | tail], stack) do
    with {:ok, stack} <- block(head, stack) do
      parse(tail, stack)
    else
      err -> err
    end
  end

  def block(char, stack) do
    case char do
      "(" -> start_block(char, stack)
      "[" -> start_block(char, stack)
      "{" -> start_block(char, stack)
      "<" -> start_block(char, stack)
      ")" -> end_block(char, stack)
      "]" -> end_block(char, stack)
      "}" -> end_block(char, stack)
      ">" -> end_block(char, stack)
    end
  end

  def start_block(char, stack) do
    {:ok, :queue.in(char, stack)}
  end

  def end_block(char, stack) do
    {{:value, open}, stack} = :queue.out_r(stack)
    case {open, char} do
      {"(", ")"} -> {:ok, stack}
      {"[", "]"} -> {:ok, stack}
      {"{", "}"} -> {:ok, stack}
      {"<", ">"} -> {:ok, stack}
      _ -> {:error, char}
    end
  end

  def generate_end_block(stack) do
    {{:value, open}, stack} = :queue.out_r(stack)
    case open do
      "(" -> {stack, ")"}
      "[" -> {stack, "]"}
      "{" -> {stack, "}"}
      "<" -> {stack, ">"}
    end
  end

  def autocomplete(stack) do
    autocomplete(stack, [])
  end

  def autocomplete(stack, added) do
    if :queue.is_empty(stack) do
      # Have to reverse the list as we added new chars to the front
      Enum.reverse(added)
    else
      {stack, new_char} = generate_end_block(stack)
      autocomplete(stack, [new_char | added])
    end

  end

end
