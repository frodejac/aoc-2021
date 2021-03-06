defmodule Aoc2021 do
  def solve(day, puzzle) do
    case {day, puzzle} do
      {:day1, :puzzle1} -> Day01.puzzle1()
      {:day1, :puzzle2} -> Day01.puzzle2()
      {:day2, :puzzle1} -> Day02.puzzle1()
      {:day2, :puzzle2} -> Day02.puzzle2()
      {:day3, :puzzle1} -> Day03.puzzle1()
      {:day3, :puzzle2} -> Day03.puzzle2()
      {:day4, :puzzle1} -> Day04.puzzle1()
      {:day4, :puzzle2} -> Day04.puzzle2()
      {:day5, :puzzle1} -> Day05.puzzle1()
      {:day5, :puzzle2} -> Day05.puzzle2()
      {:day6, :puzzle1} -> Day06.puzzle1()
      {:day6, :puzzle2} -> Day06.puzzle2()
      {:day7, :puzzle1} -> Day07.puzzle1()
      {:day7, :puzzle2} -> Day07.puzzle2()
      {:day8, :puzzle1} -> Day08.puzzle1()
      {:day8, :puzzle2} -> Day08.puzzle2()
      {:day9, :puzzle1} -> Day09.puzzle1()
      {:day9, :puzzle2} -> Day09.puzzle2()
      {:day10, :puzzle1} -> Day10.puzzle1()
      {:day10, :puzzle2} -> Day10.puzzle2()
      {:day11, :puzzle1} -> Day11.puzzle1()
      {:day11, :puzzle2} -> Day11.puzzle2()
      {:day12, :puzzle1} -> Day12.puzzle1()
      {:day12, :puzzle2} -> Day12.puzzle2()
      {:day13, :puzzle1} -> Day13.puzzle1()
      {:day13, :puzzle2} -> Day13.puzzle2()
      {:day14, :puzzle1} -> Day14.puzzle1()
      {:day14, :puzzle2} -> Day14.puzzle2()
      {:day15, :puzzle1} -> Day15.puzzle1()
      {:day15, :puzzle2} -> Day15.puzzle2()
      {:day24, :puzzle1} -> Day24.puzzle1()
      {:day24, :puzzle2} -> Day24.puzzle2()
    end
  end
end
