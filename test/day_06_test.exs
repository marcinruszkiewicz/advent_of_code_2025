defmodule Day06Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day06

  test "runs the solver for part one" do
    assert Day06.part1("test/examples/day_06.txt") == 4277556
  end

  test "runs the solver for part two" do
    assert Day06.part2("test/examples/day_06.txt") == 3263827
  end
end

