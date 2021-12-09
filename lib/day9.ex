defmodule Day9 do
  def input do
    __DIR__
    |> Path.join("day9.txt")
    |> File.stream!()
    |> process_input()
  end

  def example do
    """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """
    |> String.split("\n", trim: true)
    |> process_input()
  end

  def process_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_charlist/1)
    |> Stream.map(fn line -> Enum.map(line, &List.to_integer([&1])) end)
    |> Enum.into([])
  end

  def part_1() do
    tensor = input()

    low_points = get_low_points(tensor)

    Enum.reduce(low_points, 0, fn {_x, _y, height}, acc -> acc + height + 1 end)
  end

  def get_low_points(tensor) do
    height = width = length(tensor) - 1

    for x <- 0..width, y <- 0..height, reduce: [] do
      acc ->
        directions = get_neighbors(tensor, x, y)
        {_, _, height} = current = get_at(tensor, x, y)
        if Enum.all?(directions, fn {_, _, neighbor} -> neighbor > height end) do
          [current | acc]
        else
          acc
        end
    end
  end

  def part_2() do
    tensor = input()

    low_points = get_low_points(tensor)

    basins = Enum.map(low_points, &expand_basin(&1, [&1], tensor))

    basins
    |> Enum.sort_by(&length/1)
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(1, fn basin, acc -> acc * length(basin) end)
  end

  def get_neighbors(tensor, {x, y, _height}) do
    get_neighbors(tensor, x, y)
  end
  def get_neighbors(tensor, x, y) do
    [
      get_at(tensor, x, y-1),
      get_at(tensor, x, y+1),
      get_at(tensor, x-1, y),
      get_at(tensor, x+1, y)
    ]
    |> Enum.reject(&is_nil/1)
  end

  def get_at(tensor, x, y) do
    length = length(tensor) - 1
    if x < 0 || x > length || y < 0 || y > length do
      nil
    else
      height =
        tensor
        |> Enum.at(x)
        |> Enum.at(y)

      {x, y, height}
    end
  end

  def expand_basin(point, basin, tensor) do
    neighbors = get_neighbors(tensor, point) -- basin
    neighbors = Enum.filter(neighbors, &(elem(&1, 2) != 9))
    basin = basin ++ neighbors

    Enum.reduce(neighbors, basin, &expand_basin(&1, &2, tensor))
  end
end
