defmodule AdventOfCode.Day09 do
  defmodule Point do
    defstruct [:left, :right, :top, :bottom, :v1, :v2, :x, :y, :angle, :tl, :tr, :bl, :br]

    def new([x, y], points) do
      tl = Enum.filter(points, fn [x1, y1] -> x1 < x && y1 > y end) |> MapSet.new()
      tr = Enum.filter(points, fn [x1, y1] -> x1 > x && y1 > y end) |> MapSet.new()
      bl = Enum.filter(points, fn [x1, y1] -> x1 < x && y1 < y end) |> MapSet.new()
      br = Enum.filter(points, fn [x1, y1] -> x1 > x && y1 < y end) |> MapSet.new()

      [_, y1] =
        Enum.filter(points, fn [x1, y1] -> x1 == x && y1 != y end)
        |> Enum.min_by(fn [_, y1] -> abs(y1 - y) end)

      v1 = [0, y1 - y]

      [x1, _] =
        Enum.filter(points, fn [x1, y1] -> x1 != x && y1 == y end)
        |> Enum.min_by(fn [x1, _] -> abs(x1 - x) end)

      v2 = [x1 - x, 0]

      %Point{v1: v1, v2: v2, x: x, y: y, tl: tl, tr: tr, br: br, bl: bl}
    end

    def assign_angles(points) do
      index = points |> Enum.into(%{}, fn p -> {[p.x, p.y], p} end)
      min_coords = index |> Map.keys() |> Enum.min()
      min = index[min_coords] |> Map.put(:angle, :sharp)
      index = index |> Map.put([min.x, min.y], min)
      do_assign_angles(index, min, 0, :v1, :sharp)
    end

    def do_assign_angles(index, _, n, _, _) when map_size(index) == n, do: index |> Map.values()

    def do_assign_angles(index, p, count, dir, kind) do
      p1 = index[add(p, if(dir == :v1, do: p.v1, else: p.v2))]

      new_kind =
        if (dir == :v1 && scalar(p.v2, p1.v2) >= 0) || (dir == :v2 && scalar(p.v1, p1.v1) >= 0) do
          kind
        else
          if kind == :sharp, do: :obtuse, else: :sharp
        end

      p1 = p1 |> Map.put(:angle, new_kind)
      index = index |> Map.put([p1.x, p1.y], p1)

      do_assign_angles(index, p1, count + 1, if(dir == :v1, do: :v2, else: :v1), new_kind)
    end

    def assign_sides(points) do
      sides = sides(points)

      points
      |> Enum.map(fn p ->
        top =
          Enum.filter(sides, fn {[_, y1], [_, y2]} -> y1 == y2 && y1 > p.y end) |> MapSet.new()

        bottom =
          Enum.filter(sides, fn {[_, y1], [_, y2]} -> y1 == y2 && y1 < p.y end) |> MapSet.new()

        left =
          Enum.filter(sides, fn {[x1, _], [x2, _]} -> x1 == x2 && x1 < p.x end) |> MapSet.new()

        right =
          Enum.filter(sides, fn {[x1, _], [x2, _]} -> x1 == x2 && x1 > p.x end) |> MapSet.new()

        %{p | left: left, right: right, top: top, bottom: bottom}
      end)
    end

    def sides(points) do
      points
      |> Enum.flat_map(fn p -> [{[p.x, p.y], add(p, p.v1)}, {[p.x, p.y], add(p, p.v2)}] end)
      |> Enum.map(fn
        {[x, y1], [x, y2]} -> {[x, min(y1, y2)], [x, max(y1, y2)]}
        {[x1, y], [x2, y]} -> {[min(x1, x2), y], [max(x1, x2), y]}
      end)
      |> Enum.uniq()
    end

    def add(%Point{x: x, y: y}, [x1, y1]), do: [x + x1, y + y1]

    def area(%Point{x: x1, y: y1}, %Point{x: x2, y: y2}),
      do: (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)

    def allowed?(%Point{} = p1, %Point{} = p2) do
      [p1, p2] = sort(p1, p2)
      v12 = [p2.x - p1.x, p2.y - p1.y]
      v21 = opposite(v12)

      inside_vector?(p1, v12) && inside_vector?(p2, v21) && !intersections?(p1, p2) &&
        no_vertexes_inside?(p1, p2)
    end

    def opposite([x, y]), do: [-x, -y]

    def inside_vector?(%Point{angle: angle} = p, v) do
      if angle == :sharp do
        between_vectors?(p, v)
      else
        !between_vectors?(p, v)
      end
    end

    def between_vectors?(%Point{v1: v1, v2: v2}, v) do
      scalar(v1, v) >= 0 && scalar(v2, v) >= 0
    end

    def scalar([x1, y1], [x2, y2]), do: x1 * x2 + y1 * y2

    def no_vertexes_inside?(p1, p2) do
      if p1.y < p2.y do
        MapSet.intersection(p1.tr, p2.bl) |> Enum.empty?()
      else
        MapSet.intersection(p1.br, p2.tl) |> Enum.empty?()
      end
    end

    def intersections?(p1, p2) do
      [p1, p2] = sort(p1, p2)

      {horizontal, vertical} =
        if p1.y < p2.y do
          {MapSet.intersection(p1.top, p2.bottom), MapSet.intersection(p1.right, p2.left)}
        else
          {MapSet.intersection(p1.bottom, p2.top), MapSet.intersection(p1.right, p2.left)}
        end

      Enum.concat(horizontal, vertical)
      |> Enum.any?(fn line -> intersects?(p1, p2, line) end)
    end

    def intersects?(%Point{x: x1, y: y1}, %Point{x: x2, y: y2}, {[x3, y], [x4, y]}) do
      x = (x2 - x1) / (y2 - y1) * (y - y1) + x1
      x3 < x && x < x4
    end

    def intersects?(%Point{x: x1, y: y1}, %Point{x: x2, y: y2}, {[x, y3], [x, y4]}) do
      y = (y2 - y1) / (x2 - x1) * (x - x1) + y1
      y3 < y && y < y4
    end

    def sort(p1, p2), do: Enum.sort_by([p1, p2], fn %Point{x: x, y: y} -> {x, y} end)
  end

  # alias AdventOfCode.Utils.Board

  def part1(filename \\ "priv/day_09.txt") do
    nodes = prepare_data(filename)

    {_a, _b, area} =
      all_pairs(nodes)
      |> Enum.map(fn {a, b} -> {a, b, area(a, b)} end)
      |> Enum.sort_by(fn {_a, _b, area} -> area end)
      |> List.last()

    area
  end

  def part2(filename \\ "priv/day_09.txt") do
    points = parse(filename)

    points =
      points
      |> Enum.map(fn p -> Point.new(p, points) end)
      |> Point.assign_angles()
      |> Point.assign_sides()

    pairs(points)
    |> Enum.map(fn {p1, p2} -> (Point.allowed?(p1, p2) && Point.area(p1, p2)) || 0 end)
    |> Enum.max()
  end

  defp prepare_data(filename) do
    File.cwd!()
    |> Path.join(filename)
    |> File.read!()
    |> String.split()
    |> Enum.map(fn raw ->
      raw
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
    |> Enum.sort()
  end

  def parse(filename) do
    File.cwd!()
    |> Path.join(filename)
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn line -> String.split(line, ",") |> Enum.map(&String.to_integer/1) end)
  end

  defp all_pairs([]), do: []

  defp all_pairs([x | rest]) do
    for(y <- rest, do: {x, y}) ++ all_pairs(rest)
  end

  defp area({x1, y1}, {x2, y2}) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  defp pairs(enum) do
    l = enum |> Enum.with_index()
    for {a, i} <- l, {b, j} <- l, i < j, do: {a, b}
  end
end
