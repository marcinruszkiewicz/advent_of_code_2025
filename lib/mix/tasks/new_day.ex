defmodule Mix.Tasks.NewDay do
  @moduledoc """
  Download input for a given puzzle.

  Takes a day and year as an argument.

      $ mix new_day 02
  """
  @shortdoc "Create module and test for a new day"
  use Mix.Task

  @impl Mix.Task
  def run([day]) do
    File.write("test/day_#{day}_test.exs", AdventOfCode.Utils.NewDay.test(day))
    File.write("lib/advent_of_code/day_#{day}.ex", AdventOfCode.Utils.NewDay.code(day))
    File.touch("test/examples/day_#{day}.txt")
  end
end
