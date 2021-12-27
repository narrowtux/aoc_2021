defmodule Day24.Program do
  def execute(input) do
    w = x = y = z = 0
    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 1)
    x = x + 14
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 8
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 1)
    x = x + 15
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 11
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 1)
    x = x + 13
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 2
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 26)
    x = x + -10
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 11
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 1)
    x = x + 14
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 1
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 26)
    x = x + -3
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 5
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 26)
    x = x + -14
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 10
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 1)
    x = x + 12
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 6
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 1)
    x = x + 14
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 1
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 1)
    x = x + 12
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 11
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 26)
    x = x + -6
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 9
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 26)
    x = x + -6
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 14
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 26)
    x = x + -2
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 11
    y = y * x
    z = z + y

    [w | input] = input
    x = z
    x = Integer.mod(x, 26)
    z = div(z, 26)
    x = x + -9
    x = if x == w, do: 1, else: 0
    x = if x == 0, do: 1, else: 0
    y = 25
    y = y * x
    y = y + 1
    z = z * y
    y = w
    y = y + 2
    y = y * x
    z = z + y

    z == 0
  end
end
