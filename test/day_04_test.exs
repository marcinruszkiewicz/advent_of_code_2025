defmodule Day04Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day04

  test "runs the solver for part one" do
    assert Day04.part1("test/examples/day_04.txt") == 13
  end

  test "runs the solver for part two" do
    assert Day04.part2("test/examples/day_04.txt") == 43
  end
end

