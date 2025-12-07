defmodule AdventOfCode.Day07 do
  # alias AdventOfCode.Utils.Board

  def part1(filename \\ "priv/day_07.txt") do
    {board, max_x, max_y} = prepare_data(filename)

    {split_count, _board} = 
    Enum.reduce(0..max_y-1//1, {0, board}, fn y, {count, board} ->
      check_row(count, board, max_x, y)
    end)
    # Board.print(board, max_x, max_y)

    split_count
  end

  def check_row(count, board, max_x, y) do
    Enum.reduce(0..max_x-1//1, {count, board}, fn x, {count, board} -> 
      piece = Map.get(board, {x, y})

      case piece do
        "S" ->
          check_below(count, board, x, y)
        "|" ->
          check_below(count, board, x, y)
        _ -> 
          {count, board}
      end
    end)
  end

  def check_below(count, board, x, y) do
    piece = Map.get(board, {x, y+1})

    case piece do
      "." -> 
        new_board = Map.replace(board, {x, y+1}, "|")
        {count, new_board}
      "^" ->
        new_board = Map.replace(board, {x+1, y+1}, "|") |> Map.replace({x-1, y+1}, "|")
        {count + 1, new_board}
      _ ->
        {count, board}
    end
  end

  def part2(filename \\ "priv/day_07.txt") do
    {board, max_x, max_y} = prepare_data(filename)

    board = 
    Enum.reduce(0..max_y-1//1, board, fn y, board ->
      check_row_part2(board, max_x, y)
    end)
    # Board.print(board, max_x, max_y)


    Enum.reduce(0..max_x-1//1, [], fn x, arr ->
      piece = Map.get(board, {x, max_y-1})

      if is_integer(piece) do
        arr ++ [piece]
      else
        arr
      end
    end) 
    |> Enum.sum
  end

  def check_row_part2(board, max_x, y) do
    _board = Enum.reduce(0..max_x-1//1, board, fn x, board -> 
      piece = Map.get(board, {x, y})

      case piece do
        "S" ->
          board = Map.replace(board, {x, y}, 1)
          check_below_part2(board, x, y)
        p -> 
          if is_integer(p) do
            check_below_part2(board, x, y)
          else
            board
          end
      end
    end)
  end

  def check_below_part2(board, x, y) do
    piece = Map.get(board, {x, y+1})

    case piece do
      "." -> 
        value = Map.get(board, {x, y})
        board = Map.replace(board, {x, y+1}, value)

        # Board.print(board, 16, 16)
        board
      "^" ->
        board = replace_value_left(board, {x-1, y+1}) |> replace_value_right({x+1, y+1})
        # Board.print(board, 16, 16)

        board
      _ ->
        board
    end
  end

  defp replace_value_left(board, {x, y}) do
    right = Map.get(board, {x+1, y}, nil)# |> IO.inspect(label: "checking #{x+1}, #{y}")
    left = Map.get(board, {x-1, y}, nil)# |> IO.inspect(label: "checking #{x-1}, #{y}")

    top = Map.get(board, {x, y-1})# |> IO.inspect(label: "top")
    base = if is_integer(top), do: top, else: 0

    value = cond do
      right == "^" && left == "^" ->
        v = Map.get(board, {x+1, y-1}, 0)
        v2 = Map.get(board, {x-1, y-1}, 0)

        [v, v2] |> Enum.reject(fn i -> i == "." end) |> Enum.sum
      left == "^" ->
         v = Map.get(board, {x-1, y-1}, 0)

        [v] |> Enum.reject(fn i -> i == "." end) |> Enum.sum
      true ->
        Map.get(board, {x+1, y-1}, 0)
    end

    value = value + base

    # IO.inspect("replacing left #{x}, #{y} with #{value}")

    Map.replace(board, {x, y}, value)
  end

  defp replace_value_right(board, {x, y}) do
    right = Map.get(board, {x+1, y}, nil)# |> IO.inspect(label: "checking #{x+1}, #{y}")
    left = Map.get(board, {x-1, y}, nil)# |> IO.inspect(label: "checking #{x-1}, #{y}")

    top = Map.get(board, {x, y-1})# |> IO.inspect(label: "top")
    base = if is_integer(top), do: top, else: 0

    value = cond do
      right == "^" && left == "^" ->
        v = Map.get(board, {x+1, y-1}, 0)
        v2 = Map.get(board, {x-1, y-1}, 0)

        [v, v2] |> Enum.reject(fn i -> i == "." end) |> Enum.sum
      right == "^" ->
        v = Map.get(board, {x+1, y-1}, 0)

        [v] |> Enum.reject(fn i -> i == "." end) |> Enum.sum
      true ->
        Map.get(board, {x-1, y-1}, 0)
    end

    value = value + base

    #IO.inspect("replacing right #{x}, #{y} with #{value}")

    Map.replace(board, {x, y}, value)
  end

  defp prepare_data(filename) do
    file = File.cwd!()
    |> Path.join(filename)
    |> File.stream!()
    |> Enum.map(fn f -> String.trim(f) |> String.split("", trim: true) end)

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
end

