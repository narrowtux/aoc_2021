defmodule Day7 do
  def input do
    __DIR__
    |> Path.join("day7.txt")
    |> File.read!()
    |> process_input()
  end

  def process_input(binary) do
    binary
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def part_1 do
    solve_with_cost_fun(&abs(&2 - &1))
  end

  def part_2 do
    solve_with_cost_fun(fn
      same, same -> 0
      from, to -> Enum.sum(1..abs(to - from))
    end)
  end

  def solve_with_cost_fun(fun) do
    positions = input()
    min = Enum.min(positions)
    max = Enum.max(positions)

    possible_layers =
      for layer <- min..max do
        {layer, cost_to_move(positions, layer, fun)}
      end

    cheapest = Enum.min_by(possible_layers, &elem(&1, 1))
    most_expensive = Enum.max_by(possible_layers, &elem(&1, 1))

    Aoc2021.print_result(cheapest: cheapest, most_expensive: most_expensive)
  end

  def cost_to_move(positions, to_layer, fun) do
    Enum.map(positions, &fun.(&1, to_layer))
    |> Enum.sum()
  end
end
