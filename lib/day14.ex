defmodule Day14 do
  def example_input do
    """
    NNCB

    CH -> B
    HH -> N
    CB -> H
    NH -> C
    HB -> C
    HC -> B
    HN -> C
    NN -> C
    BH -> H
    NC -> B
    NB -> B
    BN -> B
    BB -> N
    BC -> B
    CC -> N
    CN -> C
    """
    |> String.split("\n", trim: true)
    |> process_input()
  end

  def input do
    __DIR__
    |> Path.join("day14.txt")
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> process_input()
  end

  def process_input(lines) do
    template = Enum.at(lines, 0)

    rules =
      lines
      |> Stream.drop(1)
      |> Stream.reject(&(&1 == ""))
      |> Stream.map(fn <<pair::binary-size(2), " -> ", middle::binary-size(1)>> ->
        {pair, middle}
      end)
      |> Enum.into(%{})

    {template, rules}
  end

  def string_to_pairs(string) do
    for from <- 0..(String.length(string) - 2), to = from + 1 do
      String.slice(string, from..to)
    end
  end

  def expand_pair(pair, rules) do
    case Map.get(rules, pair) do
      nil ->
        [pair]

      middle ->
        <<left::binary-size(1), right::binary-size(1)>> = pair
        [left <> middle, middle <> right]
    end
  end

  def part_1(steps \\ 10) do
    {template, rules} = input()

    polymer =
      for step <- 1..steps, reduce: template do
        polymer ->
          apply_rules(polymer, rules)
      end

    # IO.puts(polymer)

    freq = polymer |> String.to_charlist() |> Enum.frequencies()

    {{_, min}, {_, max}} = Enum.min_max_by(freq, &elem(&1, 1))
    max - min
  end

  def part_2(steps \\ 10, test_template \\ nil) do
    {template, rules} = example_input()

    template = test_template || template

    {template, added_elements} =
      template
      |> string_to_pairs()
      |> Enum.reduce({%{}, %{}}, fn pair, {pairs, added_elements} ->
        pairs = Map.update(pairs, pair, 1, &(&1 + 1))
        {_left, right} = split_pair(pair)
        {pairs, add_amount(added_elements, right)}
      end)

    {polymer, added_elements} =
      for step <- 1..steps, reduce: {template, %{}} do
        {polymer, added_elements} -> apply_rules_2(polymer, added_elements, rules)
      end

    freq =
      Enum.reduce(polymer, %{}, fn {pair, amount}, acc ->
        {left, right} = split_pair(pair)

        acc
        |> add_amount(left, amount)
        |> add_amount(right, amount)
      end)

    freq = merge_freq(freq, added_elements) |> IO.inspect()

    {{_, min}, {_, max}} = Enum.min_max_by(freq, &elem(&1, 1))
    max - min
  end

  def split_pair(<<left::binary-size(1), right::binary-size(1)>>) do
    {left, right}
  end

  def apply_rules_2(polymer, added_elements, rules) do
    {next_stage, added_elements} =
      Enum.reduce(rules, {%{}, added_elements}, fn {pair, middle}, {next_stage, added_elements} ->
        {left, right} = split_pair(pair)

        amount = Map.get(polymer, pair, 0)

        next_stage =
          next_stage
          |> add_amount(pair, -amount)
          |> add_amount(left <> middle, amount)
          |> add_amount(middle <> right, amount)

        added_elements = add_amount(added_elements, middle, amount)

        {next_stage, added_elements}
      end)

    polymer = merge_freq(polymer, next_stage)

    {polymer, added_elements}
  end

  def merge_freq(a, b) do
    a
    |> Enum.into([])
    |> Kernel.++(Enum.into(b, []))
    |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
    |> Enum.map(fn {pair, amounts} -> {pair, Enum.sum(amounts)} end)
    |> Enum.into(%{})
  end

  def add_amount(added_elements, letter, n \\ 1) do
    Map.update(added_elements, letter, n, &(&1 + n))
  end

  def apply_rules(<<first::binary-size(1), _::binary>> = polymer, rules) do
    # IO.write(first)
    apply_rules(polymer, rules, first)
  end

  def apply_rules(<<pair::binary-size(2), rest::binary>>, rules, acc) do
    <<_left::binary-size(1), right::binary-size(1)>> = pair

    acc =
      case Map.get(rules, pair) do
        nil ->
          # IO.write(right)
          acc <> right

        middle ->
          # IO.write([IO.ANSI.bright(), middle, IO.ANSI.reset(), right])
          acc <> middle <> right
      end

    apply_rules(right <> rest, rules, acc)
  end

  def apply_rules(<<_::binary-size(1)>>, _rules, acc) do
    # IO.puts("")
    acc
  end
end
