defmodule InputReader do
  @moduledoc false
  @type path :: String.t
  @spec read_lines_as_integers(String.t) :: list(integer)
  def read_lines_as_integers(path) do
    File.stream!(path)
    |> Stream.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end
end
