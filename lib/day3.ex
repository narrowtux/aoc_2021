defmodule Day3 do
  @example_input ~w[
    00100
    11110
    10110
    10111
    10101
    01111
    00111
    11100
    10000
    11001
    00010
    01010
  ]

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

    IO.puts("gamma: #{gamma_rate}")
    IO.puts("epsilon: #{epsilon_rate}")
    IO.puts("power: " <> to_string(gamma_rate * epsilon_rate))
  end

  def part_2 do
    readings = Enum.into(input(), [])

    most = filter_ratings(readings, :most) |> Integer.undigits(2)
    least = filter_ratings(readings, :least) |> Integer.undigits(2)

    IO.puts("most: #{most}")
    IO.puts("least: #{least}")
    IO.puts(to_string(most * least))
  end

  @spec filter_ratings(list(1|0), agg :: :most | :least, non_neg_integer()) :: list(1|0)
  def filter_ratings(readings, agg, index \\ 0)
  def filter_ratings([one], _, _), do: one
  # def filter_ratings(readings, _agg, 8), do: raise RuntimeError, message: "#{length(readings)} readings left"
  def filter_ratings(readings, agg, index) do
    len = length(readings)
    ones = Enum.map(readings, &Enum.at(&1, index)) |> Enum.sum()
    zeros = len - ones
    value = case {agg, ones, zeros} do
      {:most, ones, zeros} when ones >= zeros -> 1
      {:most, _, _} -> 0
      {:least, ones, zeros} when ones >= zeros -> 0
      {:least, _, _} -> 1
    end
    readings = Enum.filter(readings, &(Enum.at(&1, index) == value))
    IO.puts("#{index}: #{ones}x1, #{zeros}x0, #{value} => #{length(readings)} ratings")
    filter_ratings(readings, agg, index + 1)
  end

  def input do
    __DIR__
    |> Path.join("day3.txt")
    |> File.stream!()
    |> process_input()
  end
  def example_input() do
    @example_input
    |> process_input()
  end
  def process_input(lines) do
    lines
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
