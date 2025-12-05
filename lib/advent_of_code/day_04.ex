defmodule AdventOfCode.Day04 do
  # alias AdventOfCode.Utils.Board

  def part1(filename \\ "priv/day_04.txt") do
    {board, max_x, max_y} = prepare_data(filename)

    board = check_board(board, max_x, max_y)

    # Board.print(board, max_x, max_y)

    Map.values(board)
    |> Enum.count(fn y -> 
      y == "x"
    end)
  end

  defp check_surroundings(board, {x, y}) do
    out = []

    out = [Map.get(board, {x - 1, y - 1}) | out]
    out = [Map.get(board, {x - 1, y}) | out]
    out = [Map.get(board, {x - 1, y + 1}) | out]
    out = [Map.get(board, {x, y - 1}) | out]
    out = [Map.get(board, {x, y + 1}) | out]
    out = [Map.get(board, {x + 1, y - 1}) | out]
    out = [Map.get(board, {x + 1, y}) | out]
    out = [Map.get(board, {x + 1, y + 1}) | out]

    out
  end

  defp check_board(board, max_x, max_y) do
    board = Enum.reduce(0..max_y-1, board, fn y, board -> 
      Enum.reduce(0..max_x-1, board, fn x, board -> 
        # IO.puts("#{x}, #{y}")
        piece = Map.get(board, {x, y})
        if piece == "@" || piece == "x" do 
          surroundings = check_surroundings(board, {x, y})

          accessible = Enum.count(surroundings, fn x -> x == "@" || x == "x" end)

          if accessible < 4 do
            Map.replace(board, {x, y}, "x")
          else
            board
          end
        else
          board
        end
      end)
    end)

    # Board.print(board, max_x, max_y)

    board
  end

  def part2(filename \\ "priv/day_04.txt") do
    {board, max_x, max_y} = prepare_data(filename)

    {_board, total} = check_until(-1, 0, board, max_x, max_y)

    # Board.print(board, max_x, max_y)

    total
  end

  defp check_until(0, total, board, _max_x, _max_y), do: {board, total}

  defp check_until(_, total, board, max_x, max_y) do
    board = check_board(board, max_x, max_y)

    count = Map.values(board)
    |> Enum.count(fn y -> 
      y == "x"
    end)

    board = clear_board(board, max_x, max_y)

    check_until(count, total+count, board, max_x, max_y)
  end

  defp clear_board(board, max_x, max_y) do
    board = Enum.reduce(0..max_y-1, board, fn y, board -> 
      Enum.reduce(0..max_x-1, board, fn x, board -> 
        # IO.puts("#{x}, #{y}")
        piece = Map.get(board, {x, y})
        if piece == "x" do 
          Map.replace(board, {x, y}, ".")
        else
          board
        end
      end)
    end)

    # Board.print(board, max_x, max_y)

    board
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
