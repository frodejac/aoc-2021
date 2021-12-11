defmodule Aoc2021Test do
  use ExUnit.Case
  doctest Aoc2021

  test "Day 1, Puzzle 1" do
    assert Aoc2021.solve(:day1, :puzzle1) == 1228
  end

  test "Day 1, Puzzle 2" do
    assert Aoc2021.solve(:day1, :puzzle2) == 1257
  end

  test "Day 2, Puzzle 1" do
    assert Aoc2021.solve(:day2, :puzzle1) == 1727835
  end

  test "Day 2, Puzzle 2" do
    assert Aoc2021.solve(:day2, :puzzle2) == 1544000595
  end

  test "Day 3, Puzzle 1" do
    assert Aoc2021.solve(:day3, :puzzle1) == 3320834
  end

  test "Day 3, Puzzle 2" do
    assert Aoc2021.solve(:day3, :puzzle2) == 4481199
  end

  test "Day 4, Puzzle 1" do
    assert Aoc2021.solve(:day4, :puzzle1) == 28082
  end

  test "Day 4, Puzzle 2" do
    assert Aoc2021.solve(:day4, :puzzle2) == 8224
  end

  test "Day 5, Puzzle 1" do
    assert Aoc2021.solve(:day5, :puzzle1) == 7085
  end

  test "Day 5, Puzzle 2" do
    assert Aoc2021.solve(:day5, :puzzle2) == 20271
  end
end
