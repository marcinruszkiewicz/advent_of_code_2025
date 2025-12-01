import Config

# Put your cookie in a `config/secrets.exs` file like this:
#
# import Config
# config :advent_of_code, AdventOfCode.Utils.Input,
#   session_cookie: "..."

try do
  import_config "secrets.exs"
rescue
  _ -> :ok
end
