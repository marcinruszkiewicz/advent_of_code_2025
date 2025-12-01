defmodule AdventOfCode.Utils.Board do
  def print(board, max_x, max_y) do
    Enum.each(0..max_y, fn y ->
      Enum.each(0..max_x, fn x ->
        IO.write(Map.get(board, {x, y}))
      end)

      IO.puts("")
    end)
  end
end
