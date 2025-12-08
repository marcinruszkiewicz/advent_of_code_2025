defmodule Day08Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day08

  test "runs the solver for part one" do
    assert Day08.part1("test/examples/day_08.txt", 10) == 40
  end

  test "runs the solver for part two" do
    assert Day08.part2("test/examples/day_08.txt") == 25272
  end
end

