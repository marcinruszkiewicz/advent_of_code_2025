defmodule Day01Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day01

  test "runs the solver for part one" do
    assert Day01.part1("test/examples/day_01.txt") == 3
  end

  test "runs the solver for part two" do
    assert Day01.part2("test/examples/day_01.txt") == 6
  end

  test "part 2" do
    assert Day01.part2("test/examples/day_01_2.txt") == 2
  end
end

