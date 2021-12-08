defmodule Day8 do
  @ssd %{
    0 => "abcefg",
    1 => "cf",
    2 => "acdeg",
    3 => "acdfg",
    4 => "bcdf",
    5 => "abdfg",
    6 => "abdefg",
    7 => "acf",
    8 => "abcdefg",
    9 => "abcdfg"
  }

  @ssd_atoms Map.new(@ssd, fn {number, segments} ->
               atoms = for <<x::binary-size(1) <- segments>>, do: String.to_atom(x)
               {number, MapSet.new(atoms)}
             end)

  @unique_lengths [@ssd[1], @ssd[4], @ssd[7], @ssd[8]] |> Enum.map(&String.length/1)

  def string_to_atoms(segments) do
    for <<x::binary-size(1) <- segments>>, do: String.to_atom(x)
  end

  def render_number(number) do
    Integer.digits(number)
    |> Enum.map(&render_segments(&1, "  "))
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.intersperse("\n")
  end

  def input() do
    __DIR__
    |> Path.join("day8.txt")
    |> File.stream!()
    |> Stream.map(&decode_line/1)
  end

  def decode_line(line) do
    line = String.trim(line)
    parts = String.split(line, " | ")
    [input, output] = Enum.map(parts, &String.split(&1, " "))
    %{input: input, output: output}
  end

  def part_1 do
    lengths = @unique_lengths

    input()
    |> Stream.flat_map(&Map.get(&1, :output))
    |> Stream.filter(&(String.length(&1) in lengths))
    |> Enum.count()
  end

  def part_2 do
    input()
    |> Stream.map(fn %{input: i, output: o} ->
      mapper = &MapSet.new(string_to_atoms(&1))
      %{input: Enum.map(i, mapper), output: Enum.map(o, mapper)}
    end)
    |> Stream.map(fn %{input: i, output: o} ->
      resolved_digits = recur_2(%{}, i)
      Enum.map(o, &Map.get(resolved_digits, &1)) |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  @type segment :: :a | :b | :c | :d | :e | :f | :g
  @type cipher :: MapSet.t(segment())
  @type open_segments :: %{segment() => cipher()}
  @type resolved_segments :: %{segment() => segment()}
  @type digit :: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9

  @spec recur_2(resolved_digits :: %{digit() => MapSet.t(segment())}, [cipher()]) :: %{digit() => MapSet.t(segment)}
  def recur_2(resolved_digits, []) do
    Map.new(resolved_digits, fn {a, b} -> {b, a} end)
  end
  def recur_2(resolved_digits, [cipher | rest]) do
    possible_numbers = Enum.filter( @ssd_atoms, fn {_, normal} -> MapSet.size(normal) == MapSet.size(cipher) end)
    case possible_numbers do
      [{number, _}] ->
        recur_2(Map.put(resolved_digits, number, cipher), rest)
      _more ->
        case guess_digit(cipher, resolved_digits) do
          nil -> recur_2(resolved_digits, rest ++ [cipher])
          digit ->
            recur_2(Map.put(resolved_digits, digit, cipher), rest)
        end
    end
  end

  def guess_digit(cipher, resolved_digits) do
    size = MapSet.size(cipher)
    [zero, one, two, three, four, five, six, seven, eight, nine] = Enum.map(0..9, &Map.get(resolved_digits, &1))
    f = case {one, six} do
      {nil, _} -> nil
      {_, nil} -> nil
      {one, six} -> MapSet.intersection(one, six)
    end
    cond do
      size == 6 and not is_nil(one) and not MapSet.subset?(one, cipher) -> 6
      size == 6 and not is_nil(four) and MapSet.subset?(four, cipher) -> 9
      size == 6 and not is_nil(one) and not is_nil(four) and MapSet.subset?(one, cipher) -> 0
      size == 5 and not is_nil(one) and MapSet.subset?(one, cipher) -> 3
      size == 5 and not is_nil(one) and not is_nil(f) and MapSet.subset?(f, cipher) -> 5
      size == 5 and not is_nil(one) and not is_nil(f) -> 2
      true -> nil
    end
  end

  @spec recur(open_segments(), [cipher()]) :: resolved_segments()
  def recur(open_segments, [cipher | rest]) do
    IO.puts("\n\nopen_segments: #{inspect open_segments}")
    possible_numbers = Enum.filter( @ssd_atoms, fn {_, normal} -> MapSet.size(normal) == MapSet.size(cipher) end)

    possible_numbers = Enum.reduce(cipher, possible_numbers, fn cipher_segment, possible_numbers ->
      possible_real_segments = open_segments[cipher_segment]
      Enum.filter(possible_numbers, fn {_number, segments} ->
        res = not MapSet.disjoint?(segments, possible_real_segments)
        IO.puts("#{inspect segments} nd #{inspect possible_real_segments} = #{res}")
        res
      end)
    end)

    case possible_numbers do
      [{number, segments}] ->
        IO.puts("I'm sure that #{inspect cipher} means #{number}")
        open_segments =
          Map.new(open_segments, fn {crypted_cipher, prev_possible_segments} ->
            if MapSet.member?(cipher, crypted_cipher) do
              {crypted_cipher, MapSet.intersection(prev_possible_segments, segments)}
            else
              {crypted_cipher, prev_possible_segments}
            end
          end)
          |> remove_duplicates()

        return_or_recur(open_segments, rest)

      list ->
        IO.puts("The cipher #{inspect cipher} could mean #{inspect Enum.map(list, &elem(&1, 0))}")

        Process.sleep(1000)

        recur(open_segments, rest ++ [cipher])
    end
  end

  def remove_duplicates(open_segments) do
    open_segments
    |> Enum.map(&elem(&1, 1))
    |> Enum.frequencies()
    |> Enum.reduce(open_segments, fn {set, found}, open_segments ->
      Map.new(open_segments, fn {crypt, possible_segments} ->
        if not MapSet.equal?(set, possible_segments) and found > 1 and found == MapSet.size(set) do
          IO.puts("Removing duplicate #{inspect set}")
          {crypt, MapSet.difference(possible_segments, set)}
        else
          {crypt, possible_segments}
        end
      end)
    end)
  end

  @spec return_or_recur(open_segments(), [cipher()]) :: resolved_segments()
  def return_or_recur(open_segments, rest) do
    Process.sleep(1000)

    done? = Enum.all?(open_segments, fn {_, segments} -> MapSet.size(segments) == 1 end)
    if done? do
      Map.new(open_segments, fn {_, segments} -> segments |> Enum.at(0) end)
    else
      recur(open_segments, rest)
    end
  end

  def render_segments(digit_or_segments, sep \\ "\n")

  def render_segments(digit, sep) when digit in 0..9 do
    render_segments(@ssd[digit], sep)
  end

  def render_segments(i, sep) when is_binary(i) do
    [
      [" ", r("a", i, 4), " ", sep],
      [r("b", i), "    ", r("c", i), sep],
      [r("b", i), "    ", r("c", i), sep],
      [" ", r("d", i, 4), " ", sep],
      [r("e", i), "    ", r("f", i), sep],
      [r("e", i), "    ", r("f", i), sep],
      [" ", r("g", i, 4), " ", sep]
    ]
  end

  defp r(letter, connections, length \\ 1) do
    if String.contains?(connections, letter) do
      Stream.repeatedly(fn -> [IO.ANSI.bright(), IO.ANSI.green(), letter, IO.ANSI.reset()] end)
    else
      Stream.repeatedly(fn -> "." end)
    end
    |> Enum.take(length)
  end
end
