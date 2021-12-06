defmodule Day6 do
  def input do
    __DIR__
    |> Path.join("day6.txt")
    |> File.read!()
    |> process_input()
  end

  def process_input(binary) do
    binary
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.group_by(&(&1))
    |> Enum.map(fn {age, list} -> {age, length(list)} end)
  end

  def get_solution(school \\ input(), iterations) do
    school
    |> cycle_times(iterations)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
    |> IO.inspect()
  end

  def cycle_times(school, 0), do: school
  def cycle_times(school, times) do
    school
    |> cycle_school()
    |> cycle_times(times - 1)
  end

  def cycle_school(school) do
    school
    |> Enum.flat_map(&cycle_class/1)
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(fn {age, list} -> {age, Enum.sum(list)} end)
  end
  def cycle_class({0, amount}) do
    [{6, amount}, {8, amount}]
  end
  def cycle_class({age, amount}) do
    [{age - 1, amount}]
  end
end
