defmodule Day25 do
  def example do
    """
    v...>>.vv>
    .vv>>.vv..
    >>.>v>...v
    >>v>>.>.v.
    v>v.vv.v..
    >.>>..v...
    .vv..>.>v.
    v.v..>>v.v
    ....v..v.>
    """
    |> String.split("\n", trim: true)
    |> lines_to_map()
  end

  def lines_to_map(lines, acc \\ %{}, y \\ 0)

  def lines_to_map([], acc, _) do
    acc
  end

  def lines_to_map([first | rest], acc, y) do
    acc =
      for x <- 0..(String.length(first) - 1), reduce: acc do
        acc ->
          acc
          |> Map.put({x, y}, String.at(first, x))
          |> Map.update(:width, x + 1, &max(&1, x + 1))
      end

    acc = Map.update(acc, :height, y + 1, &max(&1, y + 1))
    lines_to_map(rest, acc, y + 1)
  end

  def input do
    File.read!(Path.join(__DIR__, "day25.txt"))
    |> String.split("\n", trim: true)
    |> lines_to_map()
  end

  def part_1 do
    map = input()

    count_until_stopped(map, 0)
  end

  def count_until_stopped(map, steps) do
    next_step = full_step(map)
    IO.puts "After #{steps + 1} steps"
    render(next_step)
    if next_step == map do
      steps + 1
    else
      Process.sleep(div(1000, 30))
      count_until_stopped(next_step, steps + 1)
    end
  end

  def full_step(map) do
    map
    |> step(">", 0)
    |> step("v", 1)
  end

  def step(map, type \\ ">", axis \\ 0, diff \\ 1) do
    size =
      case axis do
        0 -> map[:width]
        1 -> map[:height]
      end

    east_cucumbers = Enum.filter(map, &(elem(&1, 1) == type))

    moving =
      Enum.filter(east_cucumbers, fn {pos, ^type} ->
        next_pos = offset_pos(pos, axis, diff, size)
        Map.get(map, next_pos) == "."
      end)

    Enum.reduce(moving, map, fn {pos, ^type}, map ->
      next_pos = offset_pos(pos, axis, diff, size)

      map
      |> Map.put(pos, ".")
      |> Map.put(next_pos, type)
    end)
  end

  def offset_pos(pos, axis, diff, size) do
    value = elem(pos, axis)
    next_value = Integer.mod(value + diff, size)

    pos |> Tuple.delete_at(axis) |> Tuple.insert_at(axis, next_value)
  end

  def render(map) do
    for y <- 0..(map[:height] - 1) do
      for x <- 0..(map[:width] - 1) do
        Map.get(map, {x, y})
      end
    end
    |> Enum.intersperse("\n")
    |> IO.puts()
  end
end
