defmodule Day3 do
  def part_1 do
    len = Enum.count(input())

    sum = input()
    |> Enum.reduce(fn left, right ->
      left
      |> Enum.zip(right)
      |> Enum.map(fn {a, b} -> a + b end)
    end)

    gamma_rate =
      sum
      |> Enum.map(fn
        v when v > len / 2 -> 1
        _ -> 0
      end)
      |> Integer.undigits(2)

    epsilon_rate =
      sum
      |> Enum.map(fn
        v when v > len / 2 -> 0
        _ -> 1
      end)
      |> Integer.undigits(2)

    IO.puts(gamma_rate)
    IO.puts(epsilon_rate)
    IO.puts(gamma_rate * epsilon_rate)
  end


  def input do
    __DIR__
    |> Path.join("day3.txt")
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn string ->
      string
      |> String.to_charlist()
      |> Enum.map(fn
        ?0 -> 0
        ?1 -> 1
      end)
    end)
  end
end
