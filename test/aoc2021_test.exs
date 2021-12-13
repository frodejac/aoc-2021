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
    assert Aoc2021.solve(:day2, :puzzle1) == 1_727_835
  end

  test "Day 2, Puzzle 2" do
    assert Aoc2021.solve(:day2, :puzzle2) == 1_544_000_595
  end

  test "Day 3, Puzzle 1" do
    assert Aoc2021.solve(:day3, :puzzle1) == 3_320_834
  end

  test "Day 3, Puzzle 2" do
    assert Aoc2021.solve(:day3, :puzzle2) == 4_481_199
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

  test "Day 6, Puzzle 1" do
    assert Aoc2021.solve(:day6, :puzzle1) == 365_131
  end

  test "Day 6, Puzzle 2" do
    assert Aoc2021.solve(:day6, :puzzle2) == 1_650_309_278_600
  end

  test "Day 7, Puzzle 1" do
    assert Aoc2021.solve(:day7, :puzzle1) == 348_996
  end

  test "Day 7, Puzzle 2" do
    assert Aoc2021.solve(:day7, :puzzle2) == 98_231_647
  end

  test "Day 8, Puzzle 1" do
    assert Aoc2021.solve(:day8, :puzzle1) == 375
  end

  test "Day 8, Puzzle 2" do
    assert Aoc2021.solve(:day8, :puzzle2) == 1_019_355
  end

  test "Day 9, Puzzle 1" do
    assert Aoc2021.solve(:day9, :puzzle1) == 508
  end

  test "Day 9, Puzzle 2" do
    assert Aoc2021.solve(:day9, :puzzle2) == 1_564_640
  end

  test "Day 10, Puzzle 1" do
    assert Aoc2021.solve(:day10, :puzzle1) == 318_099
  end

  test "Day 10, Puzzle 2" do
    assert Aoc2021.solve(:day10, :puzzle2) == 2_389_738_699
  end

  test "Day 11, Puzzle 1" do
    assert Aoc2021.solve(:day11, :puzzle1) == 1681
  end

  test "Day 11, Puzzle 2" do
    assert Aoc2021.solve(:day11, :puzzle2) == 276
  end

  test "Day 12, Puzzle 1" do
    assert Aoc2021.solve(:day12, :puzzle1) == 5228
  end

  test "Day 12, Puzzle 2" do
    assert Aoc2021.solve(:day12, :puzzle2) == 131_228
  end

  test "Day 13, Puzzle 1" do
    assert Aoc2021.solve(:day13, :puzzle1) == 661
  end

  test "Day 13, Puzzle 2" do
    assert Aoc2021.solve(
             :day13,
             :puzzle2
           ) ==
             "" <>
               "###  #### #  # #    #  #  ##  #### ### \n" <>
               "#  # #    # #  #    # #  #  # #    #  #\n" <>
               "#  # ###  ##   #    ##   #    ###  #  #\n" <>
               "###  #    # #  #    # #  #    #    ### \n" <>
               "#    #    # #  #    # #  #  # #    #   \n" <>
               "#    #    #  # #### #  #  ##  #    #   \n"
  end
end
