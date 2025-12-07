defmodule Day07Test do
  use ExUnit.Case, async: true

  alias AdventOfCode.Day07

  test "runs the solver for part one" do
    assert Day07.part1("test/examples/day_07.txt") == 21
  end

  test "runs the solver for part two" do
    assert Day07.part2("test/examples/day_07.txt") == 40
  end

  test "runs the solver for simple test" do
    assert Day07.part1("test/examples/day_07_1.txt") == 1
  end

  test "runs the solver part2 for simple test" do
    assert Day07.part2("test/examples/day_07_1.txt") == 2
  end

  test "runs the solver part2 for other test" do
    assert Day07.part2("test/examples/day_07_2.txt") == 8
  end
end

