defmodule Aoc2021 do
  def print_result(keyword) do
    Enum.map(keyword, fn {key, value} ->
      [to_string(key), ": ", value_to_string(value)]
    end)
    |> Enum.intersperse("\n")
    |> IO.puts
  end

  def value_to_string(number) when is_number(number) do
    [IO.ANSI.yellow, to_string(number), IO.ANSI.reset]
  end

  def value_to_string(tuple) when is_tuple(tuple) do
    [IO.ANSI.green, inspect(tuple), IO.ANSI.reset]
  end
end
