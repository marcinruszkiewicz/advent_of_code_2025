defmodule AdventOfCode.Day05 do
  def part1(filename \\ "priv/day_05.txt") do
    {ranges, ids} = prepare_data(filename)
    ids = Enum.reject(ids, fn str -> str == "" end) |> Enum.map(&String.to_integer/1)
    ranges = Enum.map(ranges, fn str -> 
      [first, last] = String.split(str, "-") 
      Range.new(String.to_integer(first), String.to_integer(last), 1)
    end)

    Enum.reduce(ids, [], fn id, results -> 
      [Enum.any?(ranges, fn range -> id in range end) | results]
    end)
    |> Enum.count(fn r -> r == true end)
  end

  def part2(filename \\ "priv/day_05.txt") do
    {ranges, _ids} = prepare_data(filename)
    indexed = Enum.map(ranges, fn str -> 
      [first, last] = String.split(str, "-") 
      Range.new(String.to_integer(first), String.to_integer(last), 1)
    end)
    |> Enum.sort
    # |> IO.inspect(label: "sorted", limit: :infinity)

    do_reducing({indexed, -1, 0})
    # |> IO.inspect
    |> Enum.map(&Range.size/1)
    # |> IO.inspect
    |> Enum.sum
    # |> IO.inspect
  end

  defp do_reducing({array, 0, _}), do: array
  defp do_reducing({array, _, _}) do
    {arr, count, _} = Enum.reduce_while(0..length(array)-1, {[], 0, 0}, fn _i, {ranges, overlaps, index} -> 
      next = Enum.at(array, index+1)# |> IO.inspect(label: "next")
      cur = Enum.at(array, index)

      if next == nil do
        {:halt, {[cur | ranges], overlaps, index}}
      else
        {out, new_over, new_index} = if overlaps?(cur, next) do
          {union(cur, next), overlaps + 1, index + 2}
        else
          {cur, overlaps, index + 1}
        end

        {:cont, {[out | ranges], new_over, new_index}}
      end
    end)
    #|> IO.inspect

    do_reducing({Enum.reverse(arr), count, 0})
  end

  defp overlaps?(a..b//_, x..y//_) do
    a in x..y || b in x..y || x in a..b || y in a..b
  end

  defp union(range_1, range_2) do
    a..b//_ = normalize_range_order(range_1)
    x..y//_ = normalize_range_order(range_2)
    min(a, x)..max(b, y)
  end

  defp normalize_range_order(a..b//_) do
    if a <= b do
      a..b
    else
      b..a
    end
  end

  defp prepare_data(filename) do
    file = File.cwd!()
    |> Path.join(filename)
    |> File.stream!()
    |> Enum.map(fn f -> String.trim(f) end)

    index = Enum.find_index(file, fn str -> str == "" end)

    Enum.split(file, index)
  end
end

