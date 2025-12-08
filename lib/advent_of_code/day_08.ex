defmodule AdventOfCode.Day08 do
  def part1(filename \\ "priv/day_08.txt", limit \\ 1000) do
    boxes = prepare_data(filename) 

    sorted_pairs =
      all_pairs(boxes)
      |> Enum.sort_by(fn {a, b} -> dist2(a, b) end)  

    sorted_pairs
    |> Enum.take(limit)
    |> Enum.reduce([], &group(&2, &1))
    |> Enum.map(&MapSet.size/1)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()  
  end

  def part2(filename \\ "priv/day_08.txt") do
    boxes = prepare_data(filename)

    sorted_pairs =
      all_pairs(boxes)
      |> Enum.sort_by(fn {a, b} -> dist2(a, b) end)

    box_count = length(boxes)

    {a, b} =
      sorted_pairs
      |> Enum.reduce_while([], fn pair, acc ->
        new_acc = group(acc, pair)

        if MapSet.size(hd(new_acc)) == box_count do
          {:halt, pair}
        else
          {:cont, new_acc}
        end
      end)

    {ax, _, _} = a
    {bx, _, _} = b

    ax * bx
  end

  defp prepare_data(filename) do
    File.cwd!()
    |> Path.join(filename)
    |> File.read!()
    |> String.split
    |> Enum.map(fn raw ->
      raw
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.sort()
  end

  def all_pairs([]), do: []

  def all_pairs([x | rest]) do
    for(y <- rest, do: {x, y}) ++ all_pairs(rest)
  end

  def dist2({ax, ay, az}, {bx, by, bz}) do
    dx = ax - bx
    dy = ay - by
    dz = az - bz

    dx ** 2 + dy ** 2 + dz ** 2
  end

  def group([], {a, b}), do: [MapSet.new([a, b])]
  def group([set | rest], {a, b}) do
    cond do
      a in set and b in set -> [set | rest]
      a in set or b in set -> set |> MapSet.put(a) |> MapSet.put(b) |> do_squash(rest, {a, b}, [])
      true -> [set | group(rest, {a, b})]
    end
  end

  defp do_squash(curr, [], _, acc), do: [curr | acc]
  defp do_squash(curr, [x | rest], {a, b}, acc) do
    if a in x or b in x do
      [MapSet.union(curr, x) | rest ++ acc]
    else
      do_squash(curr, rest, {a, b}, [x | acc])
    end
  end
end