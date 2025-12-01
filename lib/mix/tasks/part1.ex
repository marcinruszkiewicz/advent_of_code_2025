defmodule Mix.Tasks.Part1 do
  @moduledoc """
  Solve the Part One of a given puzzle.

  Takes a module name as an argument. You should put the data you got from the AoC website into a proper file in the source/ directory.

      $ mix part1 Day1
  """
  @shortdoc "Solve the part one of the puzzle"
  use Mix.Task

  @impl Mix.Task
  def run(args) do
    module_name = List.first(args)

    if Enum.member?(args, "-b"),
      do:
        Benchee.run(%{
          part1: fn ->
            apply(String.to_existing_atom("Elixir.AdventOfCode." <> module_name), :part1, [])
          end
        }),
      else:
        apply(String.to_existing_atom("Elixir.AdventOfCode." <> module_name), :part1, [])
        |> IO.inspect(label: "Part One Results for #{module_name}")
  end
end
