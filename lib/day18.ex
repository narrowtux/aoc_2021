defmodule Day18 do
  @type snailfish_number :: [integer() | snailfish_number()]
  @spec reduce(snailfish_number()) :: snailfish_number()
  def reduce([a, b] = number) do
    result = cond do
      depth(number) == 5 -> explode(number)
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

  @type debris :: {:updated, snailfish_number()} | {:left | :right, integer()}

  @spec explode(snailfish_number(), integer()) :: {:debris, [debris()]}
  def explode(number, depth \\ 0)
  def explode([a, b], 5) when is_integer(a) and is_integer(b) do
    {:debris, left: a, right: b}
  end
  def explode([a, b], depth) do
    case {explode(a, depth + 1), explode(b, depth + 1)} do
      {{:debris, rest}, _} -> push_debris(a, b, rest, :right)
      {_, {:debris, rest}} -> push_debris(a, b, rest, :left)
      _ -> [a, b]
    end
  end

  @spec push_debris(snailfish_number(), snailfish_number(), debris(), :left | :right) :: {:debris, [debris()]}
  def push_debris(left, right, debris, direction) do
    {left, right} = case Keyword.get(debris, :updated) do
      nil -> {left, right}
      updated -> updated
    end

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
