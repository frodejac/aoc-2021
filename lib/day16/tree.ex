defmodule BITS do
  def parse([v1, v2, v3, 1, 0, 0 | bits]) do
    BITS.Number.new([v1, v2, v3, 1, 0, 0 | bits])
  end

  def parse([v1, v2, v3, t1, t2, t3, 0 | bits]) do
    version = Integer.undigits([v1, v2, v3], 2)
    type = Integer.undigits([t1, t2, t3], 2)
    {length_bits, data_bits} = Enum.split(bits, 15)
    length = Integer.undigits(length_bits, 2)
    {sub_packet_bits, remaining_bits} = Enum.split(data_bits, length)
    {BITS.Operator.new(version, type, parse_subpackets(sub_packet_bits, [])), remaining_bits}
  end

  def parse([v1, v2, v3, t1, t2, t3, 1 | bits]) do
    version = Integer.undigits([v1, v2, v3], 2)
    type = Integer.undigits([t1, t2, t3], 2)
    {count_bits, data_bits} = Enum.split(bits, 11)
    count = Integer.undigits(count_bits, 2)
    {subpackets, remaining_bits} = parse_subpackets(data_bits, count, [])
    {BITS.Operator.new(version, type, subpackets), remaining_bits}
  end

  def parse(_), do: :stop

  def parse_subpackets([], acc), do: acc

  def parse_subpackets(bits, acc) do
    case parse(bits) do
      {packet, remaining_bits} -> parse_subpackets(remaining_bits, [packet | acc])
      :stop -> acc
    end
  end

  def parse_subpackets(bits, 0, acc), do: {acc, bits}

  def parse_subpackets(bits, count, acc) do
    {packet, remaining_bits} = parse(bits)
    parse_subpackets(remaining_bits, count - 1, [packet | acc])
  end
end

defmodule BITS.Operator do
  defstruct [:version, :type, children: []]

  def new(version, type, children) do
    %BITS.Operator{version: version, type: operator_type(type), children: children}
  end

  def operator_type(type_id) do
    case type_id do
      0 -> :sum
      1 -> :mul
      2 -> :min
      3 -> :max
      5 -> :gt
      6 -> :lt
      7 -> :eq
    end
  end

  def op(type, values) do
    case type do
      :sum -> Enum.sum(values)
      :mul -> Enum.product(values)
      :min -> Enum.min(values)
      :max -> Enum.max(values)
      :gt -> bool_to_int(Enum.at(values, 0) > Enum.at(values, 1))
      :lt -> bool_to_int(Enum.at(values, 0) < Enum.at(values, 1))
      :eq -> bool_to_int(Enum.at(values, 0) == Enum.at(values, 1))
    end
  end

  defp bool_to_int(true), do: 1
  defp bool_to_int(false), do: 0
end

defmodule BITS.Number do
  defstruct [:version, :value, :substring]

  def new(binary_string) do
    version = Integer.undigits(Enum.slice(binary_string, 0, 3), 2)
    {value, remaining_bits} = BITS.Number.decode_value(elem(Enum.split(binary_string, 6), 1))
    {%BITS.Number{version: version, value: value}, remaining_bits}
  end

  def decode_value(binary_string) do
    {number_bits, remaining_bits} = decode_value(binary_string, [])
    {Integer.undigits(number_bits, 2), remaining_bits}
  end

  def decode_value([group_header | binary_string], acc) do
    {number, remaining_bits} = Enum.split(binary_string, 4)

    case group_header do
      1 -> decode_value(remaining_bits, acc ++ number)
      0 -> {acc ++ number, remaining_bits}
    end
  end
end

defmodule BITS.AST do
  def version_sum(ast) do
    version_sum(ast, 0)
  end

  def version_sum(%BITS.Operator{} = node, sum) do
    sum + Enum.reduce(node.children, node.version, fn child, acc -> acc + version_sum(child) end)
  end

  def version_sum(%BITS.Number{} = node, sum) do
    sum + node.version
  end

  def evaluate(%BITS.Number{} = node),
    do: node.value

  def evaluate(%BITS.Operator{} = node) do
    BITS.Operator.op(node.type, Enum.reverse(Enum.map(node.children, &evaluate/1)))
  end
end
