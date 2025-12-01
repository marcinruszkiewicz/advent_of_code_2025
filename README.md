# AdventOfCode Elixir Template

Elixir template for the [Advent of Code](https://adventofcode.com) puzzles.

## How to use this:

- Clone this repo.
- Login to the Advent of Code website with your favourite method, and grab the session cookie from the browser.
- Put that session cookie in the `config/secrets.exs` like so:

```
import Config
config :advent_of_code, AdventOfCode.Utils.Input,
  session_cookie: "..."
```

## There's a new puzzle, what do?

Puzzle data is generated on the AoC website. You need to grab your session cookie and put it into a `config/secrets.exs` file, after that you can run `mix input 1 2025` to get the inputs for day 1 of AoC 2025. They will land in the `priv` directory, which you should keep out of Github.

Then you can run `mix new_day 01` (notice the leading 0 that is necessary to add here) to generate files for the new puzzle.

## Solving a puzzle

Once you do the above, edit the test files and make it work.

- `test/examples` directory - put your example data here with a proper name (`day200.txt` etc)
- create an `AdventOfCode.Day200` module in `lib/advent_of_code/day_200.ex`. Needs to have a `part1` and an `part2` public methods, so that you can use the mix tasks to run them, otherwise it can use whatever you like.
- create a `tests/day200_test.exs` so that you can run tests: 

```assert Day200.part2("test/examples/day200.txt") == 12345```

## Running the puzzle solvers

Use the mix tasks. They both take the module name as an argument:

- `mix part1 Day200` solves the part one of the given puzzle using the `part1` method
- `mix part2 Day200` solves the part two of the given puzzle using the `part2` method

You can use the `-b` flag to run the benchmarks for the given task, so that you can improve your solution's speed if necessary.
