defmodule Day6v2 do
  def recur([add | school]) do
    school
    |> List.update_at(6, &(&1 + add))
    |> Kernel.++(add)
  end
end
