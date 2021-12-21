defmodule Day18 do
  @type snailfish_number :: [integer() | snailfish_number()]
  @spec reduce(snailfish_number()) :: snailfish_number()
  def reduce([a, b] = number) do
    result = cond do
      depth(number) == 5 -> explode(number) |> elem(0)
      largest_regular(number) >= 10 -> split(number)
      depth(number) > 5 -> [reduce(a), reduce(b)]
      true -> number
    end
    if is_reduced?(result) do
      result
    else
      reduce(result)
    end
  end

  defguard is_regular_pair(pair) when is_list(pair) and length(pair) == 2 and is_integer(hd(pair)) and is_integer(hd(tl(pair)))

  @spec explode(snailfish_number())  :: {snailfish_number(), integer(), integer()}
  def explode(number, depth \\ 0)
  def explode([pair, rest], 3) when is_regular_pair(pair) and is_integer(rest) do
    [a, b] = pair
    {rest + b, a, 0}
  end
  def explode([rest, pair], 3) when is_regular_pair(pair) and is_integer(rest) do
    [a, b] = pair
    {rest + a, 0, b}
  end
  def explode(int, _depth) when is_integer(int) do
    {int, 0, 0}
  end
  def explode([lhs, rhs], depth) do
    case {explode(lhs, depth + 1), explode(rhs, depth + 1)} do
      {{lhs, 0, 0}, {rhs, 0, 0}} ->
        {[lhs, rhs], 0, 0}

      {{lhs, left, right}, _} when left > 0 or right > 0 ->
        {rhs, right} = push_right(rhs, right)
        {[lhs, rhs], left, right}

      {_, {rhs, left, right}} when left > 0 or right > 0 ->
        {lhs, left} = push_left(lhs, left)
        {[lhs, rhs], left, right}
    end
  end

  def push_left(number, value)
  def push_left([lhs, rhs], value) when is_integer(rhs) do
    {[lhs, rhs + value], 0}
  end
  def push_left([lhs, rhs], value) do
    {rhs, rest} = push_left(rhs, value)
    {[lhs, rhs], rest}
  end
  def push_left(int, value) when is_integer(int) do
    {int + value, 0}
  end

  def push_right(number, value)
  def push_right([lhs, rhs], value) when is_integer(lhs) do
    {[lhs + value, rhs], 0}
  end
  def push_right([lhs, rhs], value) do
    {lhs, rest} = push_right(lhs, value)
    {[lhs, rhs], rest}
  end
  def push_right(int, value) when is_integer(int) do
    {int + value, 0}
  end

  @spec split(snailfish_number()) :: snailfish_number()
  def split(number) when is_integer(number) and number >= 10 do
    half = number / 2.0
    [half |> Float.floor() |> trunc(), half |> Float.ceil() |> trunc()]
  end
  def split([a, b] = number) do
    cond do
      largest_regular(number) < 10 -> number
      largest_regular(a) >= 10 -> [split(a), b]
      largest_regular(b) >= 10 -> [a, split(b)]
    end
  end

  @spec magnitude(snailfish_number()) :: integer()
  def magnitude([a, b]) do
    3 * magnitude(a) + 2 * magnitude(b)
  end
  def magnitude(number) when is_integer(number) do
    number
  end

  def depth(number) when is_integer(number) do
    0
  end
  def depth([a, b]) do
    max(depth(a), depth(b)) + 1
  end

  def is_reduced?(number) do
    depth(number) <= 4 and largest_regular(number) <= 9
  end

  def largest_regular([a, b]) do
    max(largest_regular(a), largest_regular(b))
  end
  def largest_regular(regular) when is_integer(regular) do
    regular
  end
end
