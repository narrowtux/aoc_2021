defmodule Day10 do
  @opening_brackets ["<", "[", "(", "{"]
  @closing_brackets [">", "]", ")", "}"]
  @error_score %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  @complete_score %{
    "(" => 1,
    "[" => 2,
    "{" => 3,
    "<" => 4
  }

  def example_input do
    """
    [({(<(())[]>[[{[]{<()<>>
    [(()[<>])]({[<{<<[]>>(
    {([(<{}[<>[]}>{[]{[(<()>
    (((({<>}<{<{<>}{[]{[]{}
    [[<[([]))<([[{}[[()]]]
    [{[{({}]{}}([{[{{{}}([]
    {<[[]]>}<{[{[{[]{()[[[]
    [<(<(<(<{}))><([]([]()
    <{([([[(<>()){}]>(<<{{
    <{([{{}}[<[[[<>{}]]]>[]]
    """
    |> String.split("\n", trim: true)
  end

  def input() do
    __DIR__
    |> Path.join("day10.txt")
    |> File.stream!()
    |> Stream.map(&String.trim/1)
  end

  def part_1 do
    input()
    |> Stream.map(&parse_line/1)
    |> Stream.map(fn
      {:error, score} -> score
      _ -> 0
    end)
    |> Enum.sum()
  end

  def part_2 do
    scores =
      input()
      |> Stream.map(&parse_line/1)
      |> Stream.reject(&(elem(&1, 0) == :error))
      |> Stream.map(&elem(&1, 1))
      |> Stream.map(&calculate_complete_score/1)
      |> Enum.sort()

    Enum.at(scores, div(length(scores), 2))
  end

  def parse_line(binary, score \\ 0, open_brackets \\ [])

  def parse_line(<<bracket::binary-size(1), rest::binary>>, score, open_brackets)
      when bracket in @opening_brackets do
    parse_line(rest, score, [bracket | open_brackets])
  end

  def parse_line(<<close_bracket::binary-size(1), rest_input::binary>>, score, [
        open_bracket | rest_brackets
      ])
      when close_bracket in @closing_brackets do
    if index_of(@opening_brackets, open_bracket) == index_of(@closing_brackets, close_bracket) do
      parse_line(rest_input, score, rest_brackets)
    else
      {:error, @error_score[close_bracket]}
    end
  end

  def parse_line("", 0, stack), do: {:ok, stack}

  def calculate_complete_score(stack, score \\ 0)
  def calculate_complete_score([], score), do: score

  def calculate_complete_score([bracket | stack], score) do
    calculate_complete_score(stack, score * 5 + @complete_score[bracket])
  end

  def index_of(enum, elem) do
    Enum.find_index(enum, fn o -> o == elem end)
  end
end
