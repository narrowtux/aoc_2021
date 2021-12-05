defmodule Day5 do
  @type point :: {x :: number, y :: number}
  @type line :: {point, point}
  @type plot :: %{point => non_neg_integer}

  def input do
    __DIR__
    |> Path.join("day5.txt")
    |> File.stream!()
    |> Stream.map(fn line ->
      [point_a, point_b] = String.split(line, " -> ") |> Enum.map(&String.trim/1)
      [x1, y1] = String.split(point_a, ",") |> Enum.map(&String.to_integer/1)
      [x2, y2] = String.split(point_b, ",") |> Enum.map(&String.to_integer/1)
      {{x1, y1}, {x2, y2}}
    end)
  end

  def horizontal?({{_, y1}, {_, y2}}) do
    y1 == y2
  end

  def vertical?({{x1, _}, {x2, _}}) do
    x1 == x2
  end

  def axis_aligned?(line) do
    horizontal?(line) or vertical?(line)
  end

  def part_1() do
    lines = input() |> Stream.filter(&axis_aligned?/1)
    plot = Enum.reduce(lines, %{}, &plot_line/2)
    dangerous_points = Enum.filter(plot, &dangerous?/1)
    IO.puts("points: #{length(dangerous_points)}")
  end

  def part_2() do
    plot = Enum.reduce(input(), %{}, &plot_line/2)
    dangerous_points = Enum.filter(plot, &dangerous?/1)
    IO.puts("points: #{length(dangerous_points)}")
  end

  def dangerous?({_point, lines}) do
    lines >= 2
  end

  def plot_line(line, plot) do
    for point <- line_to_list(line), reduce: plot do
      plot -> record_point(point, plot)
    end
  end

  def record_point(point, plot) do
    plot
    |> Map.put_new(point, 0)
    |> Map.update!(point, &(&1 + 1))
  end

  @spec line_to_list(line) :: [point]
  def line_to_list({{x1, y1}, {x2, y2}}) do
    dx = x2 - x1
    dy = y2 - y1

    steps = max(abs(dx), abs(dy))

    step_x = dx / steps
    step_y = dy / steps

    for step <- 0..steps do
      {trunc(x1 + step_x * step), trunc(y1 + step_y * step)}
    end
  end
end
