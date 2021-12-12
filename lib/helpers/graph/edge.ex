defmodule Graph.Edge do
  defstruct [:v1, :v2]

  def new(v1, v2), do: %Graph.Edge{v1: v1, v2: v2}

end
