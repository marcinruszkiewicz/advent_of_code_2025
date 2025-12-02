defmodule AdventOfCode.Day02 do
  def part1(filename \\ "priv/day_02.txt") do
    prepare_data(filename)
    |> Enum.map(fn i -> 
      [left, right] = String.split(i, "-") |> Enum.map(&String.to_integer/1)

      Range.new(left, right)
    end)
    |> Enum.map(fn range -> 
      Enum.map(range, fn num -> is_invalid(num) end) |> Enum.reject(&is_nil/1)
    end)
    |> List.flatten
    |> Enum.reject(&is_nil/1)
    |> Enum.sum
  end

  defp is_invalid(id) do
    id = Integer.to_string(id)
    len = String.length(id)

    if Integer.mod(len, 2) == 0 do
      compare_parts(id)
    else
      nil
    end
  end

  defp compare_parts(string) do
    len = String.length(string)

    {left, right} = String.split_at(string, Integer.floor_div(len, 2))
    if left == right do
      String.to_integer(string)
    else
      nil
    end
  end

  defp is_invalid_part2(id) do
    id = Integer.to_string(id)

    if Regex.match?(~r/^(.+)\1+$/, id) do
      id
    else
      nil
    end
  end

  def part2(filename \\ "priv/day_02.txt") do
    prepare_data(filename)
    |> Enum.map(fn i -> 
      [left, right] = String.split(i, "-") |> Enum.map(&String.to_integer/1)

      Range.new(left, right)
    end)
    |> Enum.map(fn range -> 
      Enum.map(range, fn num -> is_invalid_part2(num) end)
    end)
    |> List.flatten
    |> Enum.reject(&is_nil/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum
  end

  defp prepare_data(filename) do
    File.cwd!()
    |> Path.join(filename)
    |> File.stream!()
    |> Enum.map(fn f -> f end)
    |> Enum.at(0)
    |> String.trim()
    |> String.split(",")
  end
end

