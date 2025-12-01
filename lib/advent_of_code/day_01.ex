defmodule AdventOfCode.Day01 do
  def part1(filename \\ "priv/day_01.txt") do
    prepare_data(filename)
    |> Enum.reduce([50], fn line, acc -> 
      start_at = List.last(acc)
      {direction, rotations} = String.split_at(line, 1)
      rotations = String.to_integer(rotations)
      direction = if direction == "L", do: -1, else: 1

      new_pos = Integer.mod((start_at + (direction * rotations)), 100)

      acc ++ [new_pos]
    end) 
    |> Enum.count(fn i -> i == 0 end)
  end

  def part2(filename \\ "priv/day_01.txt") do
    {result, _} = prepare_data(filename)
    |> Enum.reduce({0, 50}, fn line, {zeros, current_position} -> 
      {direction, rotations} = String.split_at(line, 1)
      rotations = String.to_integer(rotations)
      direction = if direction == "L", do: -1, else: 1

      old_position = current_position
      num = direction * rotations

      current_position = Integer.mod((current_position + num), 100)
      modifier = if ((((current_position >= old_position && num <= 0) || (current_position <= old_position && num >= 0)) && old_position != 0) || current_position == 0), do: 1, else: 0
      new_zeros = zeros + Integer.floor_div(abs(num), 100) + modifier

      {new_zeros, current_position}
    end)

    result
  end

  defp prepare_data(filename) do
    File.cwd!()
    |> Path.join(filename)
    |> File.stream!()
    |> Enum.map(fn f -> String.trim(f) end)
  end
end

