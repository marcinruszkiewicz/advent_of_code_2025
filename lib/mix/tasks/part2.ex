defmodule Mix.Tasks.Part2 do
  @moduledoc """
  Solve the Part Two of a given puzzle.

  Takes a module name as an argument. You should put the data you got from the AoC website into a proper file in the source/ directory.

      $ mix solve Day1
  """
  @shortdoc "Solve the Part Two of the puzzle"
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    module_name = List.first(args)

    if Enum.member?(args, "-b"),
      do:
        Benchee.run(%{
          part2: fn ->
            apply(String.to_existing_atom("Elixir.AdventOfCode." <> module_name), :part2, [])
          end
        }),
      else:
        apply(String.to_existing_atom("Elixir.AdventOfCode." <> module_name), :part2, [])
        |> IO.inspect(label: "Part Two Results for #{module_name}")
  end
end
