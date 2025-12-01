defmodule Mix.Tasks.Input do
  @moduledoc """
  Download input for a given puzzle.

  Takes a day and year as an argument.

      $ mix input 1 2024
  """
  @shortdoc "Download inputs for a given puzzle"
  use Mix.Task

  @impl Mix.Task
  def run([day, year]) do
    AdventOfCode.Utils.Input.download(year, day)
  end
end
