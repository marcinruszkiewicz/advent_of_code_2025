defmodule Day02Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day02

  test "runs the solver for part one" do
    assert Day02.part1("test/examples/day_02.txt") == 1227775554
  end

  test "runs the solver for part two" do
    assert Day02.part2("test/examples/day_02.txt") == 4174379265
  end
end

