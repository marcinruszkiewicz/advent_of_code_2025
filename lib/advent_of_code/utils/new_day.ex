defmodule AdventOfCode.Utils.NewDay do
  def code(day_num) do
    ~s"""
    defmodule AdventOfCode.Day#{day_num} do
      def part1(filename \\\\ "priv/day_#{day_num}.txt") do
        prepare_data(filename)
      end

      def part2(filename \\\\ "priv/day_#{day_num}.txt") do
        prepare_data(filename)
      end

      defp prepare_data(filename) do
        File.cwd!()
        |> Path.join(filename)
        |> File.stream!()
        |> Enum.map(fn f -> f end)
      end
    end

    """
  end

  def test(day_num) do
    ~s"""
    defmodule Day#{day_num}Test do
      use ExUnit.Case, async: true

      alias AdventOfCode.Day#{day_num}

      test "runs the solver for part one" do
        assert Day#{day_num}.part1("test/examples/day_#{day_num}.txt") == 2
      end

      test "runs the solver for part two" do
        assert Day#{day_num}.part2("test/examples/day_#{day_num}.txt") == 4
      end
    end

    """
  end
end
