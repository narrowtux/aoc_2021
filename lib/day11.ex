defmodule Day11 do
  def example_input do
    """
    5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526
    """
    |> String.split("\n", trim: true)
    |> process_lines()
  end

  def input do
    """
    6636827465
    6774248431
    4227386366
    7447452613
    6223122545
    2814388766
    6615551144
    4836235836
    5334783256
    4128344843
    """
    |> String.split("\n", trim: true)
    |> process_lines()
  end

  def process_lines(lines) do
    size = length(lines) - 1

    for x <- 0..size, reduce: %{} do
      acc ->
        line = Enum.at(lines, x)

        for y <- 0..size, reduce: acc do
          acc ->
            value = String.at(line, y) |> String.to_integer()
            Map.put(acc, {x, y}, value)
        end
    end
  end

  def render_cavern(grid) do
    size = grid_size(grid) - 1

    box = ["+", List.duplicate("-", grid_size(grid) + 2), "+"]

    lines = for x <- 0..size do
      ["| " | for y <- 0..size do
        value = Map.get(grid, {x, y})

        if value == 0 do
          [IO.ANSI.bright(), "0", IO.ANSI.reset()]
        else
          to_string(value)
        end
      end ++ [" |\n"]]
    end

    IO.puts([box, "\n", lines, box])
  end

  def grid_size(grid) do
    :math.sqrt(map_size(grid)) |> trunc()
  end

  def step(grid, steps \\ 0, flashes \\ 0)
  # def step(grid, _step, flashes), do: {grid, flashes}

  def step(grid, steps, flashes) do
    {grid, _} =
      grid
      |> Map.new(fn {loc, value} -> {loc, value + 1} end)
      |> propagate_flashes()

    {grid, flashes} =
      Enum.reduce(grid, {grid, flashes}, fn {loc, value}, {grid, flashes} ->
        {value, flashes} =
          if value > 9 do
            {0, flashes + 1}
          else
            {value, flashes}
          end

        {Map.put(grid, loc, value), flashes}
      end)

    IO.puts("After step #{steps + 1}:")
    render_cavern(grid)
    IO.puts("#{flashes} flashes in total.\n")

    if not Enum.all?(grid, fn {_, value} -> value == 0 end) do
      step(grid, steps + 1, flashes)
    end
  end

  def propagate_flashes(grid, flashed_locations \\ [])

  def propagate_flashes(grid, flashed_locations) do
    Enum.reduce(grid, {grid, flashed_locations}, fn {loc, value}, {grid, flashed_locations} ->
      if value == 10 and not Enum.member?(flashed_locations, loc) do
        flashed_locations = [loc | flashed_locations]

        get_neighbors(grid, loc)
        |> Enum.reduce(grid, fn loc, grid -> Map.update!(grid, loc, &(&1 + 1)) end)
        |> propagate_flashes(flashed_locations)
      else
        {grid, flashed_locations}
      end
    end)
  end

  def get_neighbors(grid, {x, y}) do
    for dx <- -1..1, dy <- -1..1, dx != 0 || dy != 0 do
      {x + dx, y + dy}
    end
    |> Enum.filter(&Map.has_key?(grid, &1))
  end
end
