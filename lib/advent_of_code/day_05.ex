defmodule AdventOfCode.Day05 do
  def part1(filename \\ "priv/day_05.txt") do
    prepare_data(filename)
  end

  def part2(filename \\ "priv/day_05.txt") do
    prepare_data(filename)
  end

  defp prepare_data(filename) do
    File.cwd!()
    |> Path.join(filename)
    |> File.stream!()
    |> Enum.map(fn f -> String.trim(f) end)
  end
end

