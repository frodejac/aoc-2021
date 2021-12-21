defmodule Day19.Scanner do
  import Helpers.Geometry

  alias Day19.Scanner, as: Scanner

  defstruct [:beacons, :rotation, :translation]

  def new(beacons) do
    %Scanner{
      beacons: beacons,
      rotation: [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
      translation: {0, 0, 0}
    }
  end

  def translate_scanner(scanner, translation) do
    %Scanner{
      scanner
      | beacons: Enum.map(scanner.beacons, fn point -> translate(point, translation) end),
        translation: translation
    }
  end

  def rotate_scanner(scanner, rotation) do
    %Scanner{
      scanner
      | beacons: Enum.map(scanner.beacons, fn point -> rotate(point, rotation) end),
        rotation: rotation
    }
  end

  def align_scanner(scanner, translation, rotation) do
    translate_scanner(rotate_scanner(scanner, rotation), translation)
  end

  def find_alignment(aligned, unaligned) when is_map(aligned) and is_map(unaligned) do
    {translation, count} =
      for p1 <- aligned.beacons, p2 <- unaligned.beacons do
        translation(p1, p2)
      end
      |> Enum.frequencies()
      |> Enum.max_by(&elem(&1, 1))

    if count >= 12, do: translation, else: nil
  end

  def find_alignment(aligned, unaligned) when is_map(unaligned) do
    for rotation <- rotations(), aligned_scanner <- aligned do
      {find_alignment(aligned_scanner, rotate_scanner(unaligned, rotation)), rotation}
    end
    |> List.flatten()
    |> Enum.reject(&is_nil(elem(&1, 0)))
    |> List.first()
  end

  def find_alignment(aligned, [head | tail]) do
    case find_alignment(aligned, head) do
      nil -> find_alignment(aligned, tail)
      {translation, rotation} -> {head, translation, rotation}
    end
  end

  def align([first | rest]), do: align([first], rest)

  def align(aligned, []), do: aligned

  def align(aligned, unaligned) do
    {alignable_scanner, translation, rotation} = find_alignment(aligned, unaligned)
    unaligned = unaligned -- [alignable_scanner]
    aligned = [align_scanner(alignable_scanner, translation, rotation) | aligned]
    align(aligned, unaligned)
  end

  def distances([p1, p2]) do
    [Helpers.Geometry.manhattan_distance(p1, p2)]
  end

  def distances([p1 | tail]) do
    Enum.map(tail, fn p2 -> Helpers.Geometry.manhattan_distance(p1, p2) end) ++ distances(tail)
  end
end
