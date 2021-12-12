defmodule Graph.Vertex do
  def is_start?(vertex), do: vertex == "start"
  def is_end?(vertex), do: vertex == "end"
  def is_big?(vertex), do: String.match?(vertex, ~r/[A-Z]+/)

end
