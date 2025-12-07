defmodule AdventOfCode.Utils.EnumUtils do
  def transpose(enum) do
    Enum.zip_with(enum, &Function.identity/1)
  end
end
