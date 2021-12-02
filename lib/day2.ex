defmodule Day2 do
  def part_1 do
    %{x: x, y: y} = input()
    |> Enum.reduce(%{x: 0, y: 0}, fn
      {:forward, x}, acc -> Map.update!(acc, :x, &(&1 + x))
      {:up, y}, acc -> Map.update!(acc, :y, &(&1 - y))
      {:down, y}, acc -> Map.update!(acc, :y, &(&1 + y))
    end)

    IO.puts(x * y)
  end

  def part_2 do
    acc = %{depth: 0, horizontal: 0, aim: 0}
    %{depth: d, horizontal: h} =
      input()
      |> Enum.reduce(acc, fn
        {:forward, x}, acc ->
          acc
          |> Map.update!(:depth, &(&1 + x * acc.aim))
          |> Map.update!(:horizontal, &(&1 + x))

          {:up, x}, acc -> Map.update!(acc, :aim, &(&1 - x))
          {:down, x}, acc -> Map.update!(acc, :aim, &(&1 + x))
      end)

    IO.puts(d * h)
  end

  def input do
    __DIR__
    |> Path.join("day2.txt")
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&parse_line/1)
  end

  def parse_line(line) do
    case line do
      "forward " <> num -> {:forward, String.to_integer(num)}
      "up " <> num -> {:up, String.to_integer(num)}
      "down " <> num -> {:down, String.to_integer(num)}
    end
  end
end
