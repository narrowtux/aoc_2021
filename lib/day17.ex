defmodule Day17 do
  @target_x 150..193
  @target_y -136..-86

  def simulate(pos \\ {0,0}, velocity, target_x \\ @target_x, target_y \\ @target_y, acc \\ [], steps \\ 100)
  def simulate(_, _, _, _, acc, 0), do: Enum.reverse(acc)
  def simulate({x, y}, {dx, dy}, target_x, target_y, acc, steps) do
    pos = {x + dx, y + dy}
    dx = case dx do
      0 -> 0
      negative when negative < 0 -> dx + 1
      positive when positive > 0 -> dx - 1
     end
    velocity = {dx, dy - 1}
    simulate(pos, velocity, target_x, target_y, [pos | acc], steps - 1)
  end

  def try(x_range, y_range) do
    target_x = @target_x
    target_y = @target_y

    csv = for dx <- x_range, dy <- y_range, reduce: [] do
      acc ->
        # IO.write "Running simulation with velocity #{inspect {dx, dy}} ..."
        path = simulate({0,0}, {dx, dy}, target_x, target_y, [], 1500)
        if Enum.any?(path, fn {x, y} ->
          x in target_x and y in target_y
        end) do
          {_min_x, _max_x, _min_y, max_y} = get_bbox(path)
          # IO.puts " hit! y_max=#{max_y}"
          [{dx, dy, max_y} | acc]
        else
          # IO.puts " no hit."
          acc
        end
    end
    |> Enum.map(fn tup -> tup |> Tuple.to_list() |> Enum.map(&to_string/1) |> Enum.intersperse(",") end)
    |> Enum.intersperse("\n")
    File.write!("day17.csv", csv)
  end

  def get_bbox(path) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(path, &elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(path, &elem(&1, 1))
    {min_x, max_x, min_y, max_y}
  end

  def print(start \\ {0, 0}, path, target_x, target_y) do
    all_points = [start | path]
    {min_x, max_x, min_y, max_y} = get_bbox(all_points)

    IO.puts("y_max=#{max_y}")

    for y <- max_y..min_y//-1 do
      for x <- min_x..max_x do
        pos = {x, y}
        cond do
          pos == start -> "S"
          pos in path -> "#"
          x in target_x and y in target_y -> "T"
          true -> "."
        end
      end
    end
    |> Enum.intersperse("\n")
    |> IO.puts
  end

  def run(vel_x, vel_y) do
    path = simulate({vel_x, vel_y})
    print(path, @target_x, @target_y)
  end
end
