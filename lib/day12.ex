defmodule Day12 do
  def input do
    """
    xx-end
    EG-xx
    iy-FP
    iy-qc
    AB-end
    yi-KG
    KG-xx
    start-LS
    qe-FP
    qc-AB
    yi-start
    AB-iy
    FP-start
    iy-LS
    yi-LS
    xx-AB
    end-KG
    iy-KG
    qc-KG
    FP-xx
    LS-qc
    FP-yi
    """
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "-"))
    |> Enum.flat_map(fn [from, to] ->
      [[from, to], [to, from]]
    end)
  end

  def start?(cave), do: cave == "start"
  def end?(cave), do: cave == "end"
  def small?(<<letter::binary-size(1), _rest::binary>>), do: String.downcase(letter) == letter
  def big?(cave), do: not small?(cave)

  def next_caves(cave, edges) do
    for [from, to] <- edges, from == cave do
      to
    end
  end

  def part_1 do
    edges = input()

    paths = find_paths("start", edges)
  end

  def small_loop?(path, edges) do
    edges
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.filter(&small?/1)
    |> Enum.any?(fn cave -> (Enum.filter(path, & &1 == cave) |> length()) >= 2 end)
  end

  def find_paths(current_cave, edges, current_path \\ [])
  def find_paths("end", _, current_path), do: [["end" | current_path]]

  def find_paths(cave, edges, current_path) do
    if not (small?(cave) and cave in current_path and small_loop?(current_path, edges)) do
      current_path = [cave | current_path]
      for next_cave <- next_caves(cave, edges),
          final_path <- find_paths(next_cave, edges, current_path) do
        final_path
      end
    else
      []
    end
  end
end
