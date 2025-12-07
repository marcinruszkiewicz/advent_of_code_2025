defmodule AdventOfCode.Day06 do
  # alias AdventOfCode.Utils.Board
  alias AdventOfCode.Utils.EnumUtils

  def part1(filename \\ "priv/day_06.txt") do
    {board, max_x, max_y} = prepare_data(filename)

    _results = Enum.map(0..max_x-1, fn x -> 
      op = Map.get(board, {x, max_y-1})
      first = Map.get(board, {x, 0}) |> String.to_integer

      Enum.reduce(1..max_y-2, first, fn y, acc -> 
        val = Map.get(board, {x, y}) |> String.to_integer()

        out = case op do
          "+" -> acc + val
          "*" -> acc * val
        end

        out
      end)
    end)
    # |> IO.inspect
    |> Enum.sum
  end

  def part2(filename \\ "priv/day_06.txt") do
    file = prepare_data_part2(filename)

    operations = List.last(file) |> String.split(~r{[\+\*]\s+}, include_captures: true, trim: true)

    max_file = length(file) - 1

    file = 
      List.delete_at(file, max_file) 
      |> Enum.map(fn i -> String.split(i, "", trim: true) end)
      # |> IO.inspect

    lengths = Enum.reduce(operations, [], fn op, acc -> 
      len = String.length(op)

      acc ++ [len]
    end)

    max_ops = length(operations) - 1

    {_, total} = Enum.reduce(0..max_ops, {0, 0}, fn i, {index, sum} -> 
      size = Enum.at(lengths, i)
      op = Enum.at(operations, i) |> String.trim()

      # IO.inspect("getting from #{index} to #{index + size} for #{op}")

      slice = Enum.map(0..max_file-1//1, fn ii -> 
        line = Enum.at(file, ii)

        Enum.slice(line, index, size)
      end) 
      |> EnumUtils.transpose()
      |> Enum.map(fn ar -> Enum.join(ar, "") |> String.trim() end)
      |> Enum.reject(fn i -> i == "" end)
      |> Enum.map(&String.to_integer/1)
      # |> IO.inspect(label: "sliced numbers")


      value = Enum.reduce(1..length(slice)-1//1, List.first(slice), fn i, acc -> 
        val = Enum.at(slice, i)

        out = case op do
          "+" -> acc + val
          "*" -> acc * val
        end

        out
      end)
      # IO.inspect("getting from #{index} to #{index + size} for #{op}: #{value}")

      {index + size, sum + value}
    end)
    # |> IO.inspect

    total
  end

  defp prepare_data(filename) do
    file = File.cwd!()
    |> Path.join(filename)
    |> File.stream!()
    |> Enum.map(fn f -> String.trim(f) |> String.split(" ", trim: true) end)
    # |> IO.inspect

    max_y = Enum.count(file)
    max_x = Enum.count(List.first(file))

    map =
      file
      |> Enum.with_index()
      |> Enum.map(fn {columns, row} ->
        Enum.with_index(columns)
        |> Map.new(fn {val, col} -> {{col, row}, val} end)
      end)
      |> List.flatten()
      |> Enum.reduce(&Map.merge/2)

    {map, max_x, max_y}
  end

  defp prepare_data_part2(filename) do
    file = File.cwd!()
    |> Path.join(filename)
    |> File.stream!()
    |> Enum.map(fn f -> String.replace(f, "\n", "") end)
    # |> IO.inspect

    file
  end
end

