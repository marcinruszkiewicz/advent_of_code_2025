defmodule Day09Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day09

  test "runs the solver for part one" do
    assert Day09.part1("test/examples/day_09.txt") == 50
  end

  test "runs the solver for part two" do
    assert Day09.part2("test/examples/day_09.txt") == 24
  end
end
