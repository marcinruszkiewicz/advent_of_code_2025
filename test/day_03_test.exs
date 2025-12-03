defmodule Day03Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day03

  test "runs the solver for part one" do
    assert Day03.part1("test/examples/day_03.txt") == 357
  end

  test "runs the solver for part two" do
    assert Day03.part2("test/examples/day_03.txt") == 3121910778619
  end
end

