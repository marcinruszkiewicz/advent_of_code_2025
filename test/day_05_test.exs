defmodule Day05Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day05

  test "runs the solver for part one" do
    assert Day05.part1("test/examples/day_05.txt") == 2
  end

  test "runs the solver for part two" do
    assert Day05.part2("test/examples/day_05.txt") == 4
  end
end

