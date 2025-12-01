defmodule AdventOfCode.Utils.Input do
  @moduledoc """
  Input downloader for AoC.

  Use with care and do not spam it. The inputs don't change once they're generated.
  """

  @doc """
  Download the inputs for a given day
  """
  def download(year, day) do
    {:ok, {{~c"HTTP/1.1", 200, ~c"OK"}, _, input}} =
      :httpc.request(
        :get,
        {~c"https://adventofcode.com/#{year}/day/#{day}/input", headers()},
        [],
        []
      )

    save!(day, input)
  end

  defp headers,
    do: [
      {~c"user-agent", ~c"github.com/mruszkiewicz/advent_of_code_elixir_template"},
      {~c"cookie", String.to_charlist("session=" <> Keyword.get(config(), :session_cookie))}
    ]

  defp save!(day, input) do
    num = String.pad_leading(day, 2, "0")
    path = File.cwd!() |> Path.join("priv/day_#{num}.txt")
    :ok = File.write(path, input)
  end

  defp config, do: Application.get_env(:advent_of_code, __MODULE__)
end
