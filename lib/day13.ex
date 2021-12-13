defmodule Day13 do
  def example_input do
    """
    6,10
    0,14
    9,10
    0,3
    10,4
    4,11
    6,0
    6,12
    4,1
    0,13
    10,12
    3,4
    3,0
    8,4
    1,10
    2,14
    8,10
    9,0

    fold along y=7
    fold along x=5
    """
    |> String.split("\n")
    |> process_input()
  end

  def input do
    __DIR__
    |> Path.join("day13.txt")
    |> File.stream!()
    |> process_input()
  end

  def process_input(list) do
    instructions =
      list
      |> Stream.map(&String.trim/1)
      |> Stream.reject(& &1 == "")
      |> Stream.map(fn
        "fold along x=" <> number -> {:fold, :x, String.to_integer(number)}
        "fold along y=" <> number -> {:fold, :y, String.to_integer(number)}
        point -> {:point, String.split(point, ",") |> Enum.map(&String.to_integer/1) |> List.to_tuple()}
      end)
      |> Enum.into([])

    points = Enum.filter(instructions, & elem(&1, 0) == :point)
    folds = Enum.filter(instructions, & elem(&1, 0) == :fold)

    points = Enum.map(points, fn {:point, {x, y}} -> Nx.tensor([x, y]) end)


    {points, folds}
  end

  def part_1 do
    {points, [fold | _]} = input()

    apply_fold(points, fold)

    length(points)
  end

  def part_2 do
    {points, folds} = input()

    points = Enum.reduce(folds, points, &apply_fold(&2, &1))

    points = Enum.map(points, &Nx.to_flat_list/1)

    draw_paper(points)
  end

  def draw_paper(points) do
    {width, height} = Enum.reduce(points, {0, 0}, fn [x, y], {width, height} ->
      {max(x + 1, width), max(y + 1, height)}
    end)

    blank = List.duplicate(List.duplicate(".", width) ++ ["\n"], height)

    Enum.reduce(points, blank, fn [x, y], paper ->
      List.update_at(paper, y, fn line -> List.update_at(line, x, fn _ -> "#" end) end)
    end)
    |> IO.puts()
  end

  def apply_fold(points, fold) do
    ops = fold_operations(fold)

    {left, right} = split_points(points, fold)


    right = Enum.reduce(ops, right, fn op, points ->
      Enum.map(points, &apply_op(&1, op))
    end)

    Enum.uniq(left ++ right)
  end

  def split_points(points, fold) do
    filter = case fold do
      {:fold, :x, at} -> fn point -> Nx.to_number(point[0]) > at end
      {:fold, :y, at} -> fn point -> Nx.to_number(point[1]) > at end
    end
    {Enum.reject(points, filter), Enum.filter(points, filter)}
  end

  def fold_operations({:fold, :x, at}) do
    [
      {:multiply, Nx.tensor([-1, 1])},
      {:add, Nx.tensor([at * 2, 0])}
    ]
  end
  def fold_operations({:fold, :y, at}) do
    [
      {:multiply, Nx.tensor([1, -1])},
      {:add, Nx.tensor([0, at * 2])}
    ]
  end
  def apply_op(lhs, {op, rhs}), do: apply(Nx, op, [lhs, rhs])

  def fold_point(point, fold) do
    ops = fold_operations(fold)
    Enum.reduce(ops, point, &apply_op(&2, &1))
  end
end
