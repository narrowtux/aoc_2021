defmodule Day1 do
  def part_1 do
    input()
    |> count_increases()
    |> IO.inspect()
  end

  def part_2 do
    input()
    |> window(3, &Kernel.+/2)
    |> count_increases()
    |> IO.inspect()
  end

  def count_increases(enum) do
    {inc, _acc} =
      Enum.reduce(enum, {0, nil}, fn
        current, {acc, nil} ->
          {acc, current}

        current, {acc, previous} when current > previous ->
          {acc + 1, current}

        current, {acc, _} ->
          {acc, current}
      end)

    inc
  end

  def window(enum, length \\ 3, reducer \\ &Kernel.+/2) do
    {output, _acc} =
      Enum.reduce(enum, {[], []}, fn value, {acc, windows} ->
        windows =
          [[] | windows]
          |> Enum.map(&[value | &1])

        filter = &(length(&1) >= length)

        ready_windows =
          Enum.filter(windows, filter)
          |> Enum.map(&Enum.reduce(&1, reducer))
          |> Enum.reverse()

        windows = Enum.reject(windows, filter)

        {acc ++ ready_windows, windows}
      end)

    output
  end

  def input do
    __DIR__
    |> Path.join("day1.txt")
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
  end
end
