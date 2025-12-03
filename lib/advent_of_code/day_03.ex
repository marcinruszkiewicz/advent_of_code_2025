defmodule AdventOfCode.Day03 do
  def part1(filename \\ "priv/day_03.txt") do
    prepare_data(filename)
    |> Enum.map(fn batteries -> 
      {first, _} = Enum.split(batteries, -1)
      max_first = Enum.max(first)
      index = Enum.find_index(first, fn x-> x == max_first end)
      {_, rest} = Enum.split(batteries, index+1)

      max_rest = Enum.max(rest)

      String.to_integer("#{max_first}#{max_rest}")
    end)
    |> Enum.sum
  end

  def part2(filename \\ "priv/day_03.txt") do
    prepare_data(filename)
    |> Enum.map(fn batteries -> 
      indexed = Enum.with_index(batteries, fn element, index -> {index, element} end)
      {_, max} = Enum.reduce(-11..0//1, {indexed, []}, fn counter, {input, result} -> 
        total = length(indexed)
        find_index = total + counter

        {_, first} = Enum.split_with(input, fn {i, v} -> i >= find_index end)
        {max_index, max_first} = Enum.max_by(first, fn {i, v} -> v end)
        {rest, _} = Enum.split_with(input, fn {i, v} -> i > max_index end) 

        {rest, result ++ [max_first]}
      end) 

      Enum.map(max, &Integer.to_string/1) 
      |> Enum.join("")
      |> String.to_integer
    end)
    |> Enum.sum
  end

  defp prepare_data(filename) do
    File.cwd!()
    |> Path.join(filename)
    |> File.stream!()
    |> Enum.map(fn f -> String.trim(f) |> String.split("", trim: true) |> Enum.map(&String.to_integer/1) end)
  end
end

