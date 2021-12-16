defmodule Day15 do
  def example_input do
    """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """
    |> String.split("\n", trim: true)
    |> process_input()
  end

  def input do
    __DIR__
    |> Path.join("day15.txt")
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> process_input()
  end

  def process_input(stream) do
    array =
      Enum.map(stream, fn line ->
        for <<risk::binary-size(1) <- line>>, do: String.to_integer(risk)
      end)

    for y <- 0..(length(array) - 1), reduce: %{} do
      acc ->
        line =
          for x <- 0..(length(Enum.at(array, y)) - 1), reduce: %{} do
            acc ->
              Map.put(acc, {x, y}, array |> Enum.at(y) |> Enum.at(x))
          end

        Map.merge(acc, line)
    end
  end

  def eastar_env(cave, expand \\ false) do
    {
      &neighbors(cave, &1, expand),
      &distance(cave, &1, &2, expand),
      &heuristic(cave, &1, &2, expand)
    }
  end

  def part_1 do
    cave = input()

    find_path(cave, false)
  end

  def part_2 do
    cave = input()

    find_path(cave, true)
  end

  def render(cave, expand \\ true, path \\ []) do
    size = :math.sqrt(map_size(cave)) |> trunc() |> Kernel.*(if expand, do: 5, else: 1)

    for y <- 0..(size - 1) do
      row = for x <- 0..(size - 1) do
        risk = get_risk(cave, x, y, expand)

        if {x, y} in path do
          [IO.ANSI.bright(), to_string(risk), IO.ANSI.reset()]
        else
          to_string(risk)
        end
      end

      [row, "\n"]

    end
    |> IO.puts

    :ok
  end

  def find_path(cave, expand) do
    size = :math.sqrt(map_size(cave)) |> trunc() |> Kernel.*(if expand, do: 5, else: 1)

    path = Astar.astar(eastar_env(cave, expand), {0, 0}, {size - 1, size - 1})

    render(cave, expand, path)

    path
    |> Enum.map(&get_risk(cave, elem(&1, 0), elem(&1, 1), expand))
    |> Enum.sum()
  end

  def neighbors(cave, {x, y}, expand) do
    for dx <- -1..1,
        dy <- -1..1,
        dx != 0 or dy != 0,
        dx == 0 or dy == 0,
        neighbor_loc = {x + dx, y + dy},
        neighbor = get_risk(cave, x + dx, y + dy, expand),
        not is_nil(neighbor) do
      neighbor_loc
    end
  end

  def distance(cave, _, {x, y}, expand) do
    # return the risk for point b
    get_risk(cave, x, y, expand)
  end

  def heuristic(_cave, {x1, y1}, {x2, y2}, _expand) do
    # return the distance between point a and b
    abs(x1 - x2) + abs(y1 - y2)
  end

  def get_risk(cave, x, y, expand \\ false) do
    size = :math.sqrt(map_size(cave)) |> trunc()

    ox = div(x, size)
    oy = div(y, size)

    if ox >= 5 or oy >= 5 do
      nil
    else
      offset = ox + oy

      location =
        case expand do
          true -> {x - ox * size, y - oy * size}
          false -> {x, y}
        end

      case Map.get(cave, location) do
        nil -> nil
        risk -> wrap(risk + offset)
      end
    end
  end

  def wrap(risk) when risk <= 9 do
    risk
  end

  def wrap(risk) when risk > 9 do
    wrap(risk - 9)
  end
end
