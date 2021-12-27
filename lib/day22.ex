defmodule Day22 do
  def input do
    Path.join(__DIR__, "day22.txt")
    |> File.stream!()
    |> process_input()
  end
  def process_input(input) do
    input
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn
      "on " <> rest -> [true | parse_range(rest)] |> List.to_tuple()
      "off " <> rest -> [false | parse_range(rest)] |> List.to_tuple()
    end)
  end
  def parse_range(range) do
    ["x=" <> x, "y=" <> y, "z=" <> z] = String.split(range, ",")
    to_range = fn range ->
      [from, to] = range |> String.split("..") |> Enum.map(&String.to_integer/1)
      from..to
    end
    Enum.map([x, y, z], to_range)
  end
  def example_input() do
    """
    on x=-20..26,y=-36..17,z=-47..7
    on x=-20..33,y=-21..23,z=-26..28
    on x=-22..28,y=-29..23,z=-38..16
    on x=-46..7,y=-6..46,z=-50..-1
    on x=-49..1,y=-3..46,z=-24..28
    on x=2..47,y=-22..22,z=-23..27
    on x=-27..23,y=-28..26,z=-21..29
    on x=-39..5,y=-6..47,z=-3..44
    on x=-30..21,y=-8..43,z=-13..34
    on x=-22..26,y=-27..20,z=-29..19
    off x=-48..-32,y=26..41,z=-47..-37
    on x=-12..35,y=6..50,z=-50..-2
    off x=-48..-32,y=-32..-16,z=-15..-5
    on x=-18..26,y=-33..15,z=-7..46
    off x=-40..-22,y=-38..-28,z=23..41
    on x=-16..35,y=-41..10,z=-47..6
    off x=-32..-23,y=11..30,z=-14..3
    on x=-49..-5,y=-3..45,z=-29..18
    off x=18..30,y=-20..-8,z=-3..13
    on x=-41..9,y=-7..43,z=-33..15
    on x=-54112..-39298,y=-85059..-49293,z=-27449..7877
    on x=967..23432,y=45373..81175,z=27513..53682
    """
    |> String.split("\n")
    |> Enum.reject(& &1 == "")
    |> process_input()
  end
  def example_input_2() do
    """
    on x=10..12,y=10..12,z=10..12
    on x=11..13,y=11..13,z=11..13
    off x=9..11,y=9..11,z=9..11
    on x=10..10,y=10..10,z=10..10
    """
    |> String.split("\n")
    |> Enum.reject(& &1 == "")
    |> process_input()
  end

  def part_1 do
    steps = input()

    Enum.reduce(steps, MapSet.new(), fn {state, x_range, y_range, z_range}, acc ->
      [x_range, y_range, z_range] = Enum.map([x_range, y_range, z_range], &limit_range/1)
      for x <- x_range, y <- y_range, z <- z_range, reduce: acc do
        acc -> if state do
          MapSet.put(acc, {x, y, z})
        else
          MapSet.delete(acc, {x, y, z})
        end
      end
    end)
    |> MapSet.size()
  end
  def limit_range(from..to = range) do
    if Range.disjoint?(range, -50..50) do
      []
    else
      max(-50, from)..min(50, to)
    end
  end

  def cube_intersect(a, b) do
    [a.x..b.x, a.y..b.y, a.z..b.z]
  end
end
