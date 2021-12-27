defmodule Day24 do
  defmodule Parser do
    import Combine.Parsers.Text
    import Combine.Parsers.Base

    def parser() do
      many(
        sequence([
          instruction(),
          skip(string("\n"))
        ])
      )
      |> map(&List.flatten/1)
    end

    def instruction() do
      choice([input(), add(), mul(), div(), mod(), eql()])
    end

    def input() do
      sequence([
        string("inp "),
        variable()
      ])
      |> map(fn ["inp ", variable] -> {:input, variable} end)
    end

    for op <- ~w[add mul div mod eql]a do
      def unquote(op)() do
        binary_op(unquote(to_string(op)))
      end
    end

    def binary_op(op) do
      sequence([
        string("#{op} "),
        variable(),
        string(" "),
        variable_or_value()
      ])
      |> map(fn [_op, a, " ", b] -> {String.to_atom(op), a, b} end)
    end

    def variable() do
      letter()
      |> map(&String.to_atom/1)
    end

    def value() do
      sequence([
        either(string("-"), digit()),
        many(digit())
      ])
      |> map(&List.flatten/1)
      |> map(fn
        ["-" | digits] -> -(Integer.undigits(digits))
        digits -> Integer.undigits(digits)
      end)
    end

    def variable_or_value() do
      choice([variable(), value()])
    end
  end

  def int_to_bits() do
    """
    inp w
    add z w
    mod z 2
    div w 2
    add y w
    mod y 2
    div w 2
    add x w
    mod x 2
    div w 2
    mod w 2
    """
    |> Combine.parse(__MODULE__.Parser.parser())
    |> List.first()
  end

  def input_program() do
    Path.join(__DIR__, "day24.txt")
    |> Combine.parse_file(__MODULE__.Parser.parser())
    |> List.first()
  end

  def eval(program \\ input_program(), input) do
    acc = %{input: input}
    Enum.reduce(program, acc, &eval_instruction/2)
  end

  def program_to_elixir() do
    program = input_program()
    inits = "a = b = w = x = y = z = 0"
    lines = Enum.map(program, fn
      {:input, var} -> "[#{var} | input] = input"
      {:mod, a, b} -> "#{a} = Integer.mod(#{a}, #{b})"
      {:add, a, b} -> "#{a} = #{a} + #{b}"
      {:mul, a, b} -> "#{a} = #{a} * #{b}"
      {:div, a, b} -> "#{a} = div(#{a}, #{b})"
      {:eql, a, b} -> "#{a} = if #{a} == #{b}, do: 1, else: 0"
    end)
    |> Enum.map(&("    " <> &1))

    lines = [inits | lines] |> Enum.join("\n")
    """
    defmodule Day24.Program do
      def execute(input) do
        #{lines}

        z == 0
      end
    end
    """
  end

  def eval_instruction({:input, variable}, acc) do
    # IO.puts "#{variable} = input"
    case acc[:input] do
      [] ->
        raise "no inputs left"

      [value | rest] ->
        acc
        |> Map.put(variable, value)
        |> Map.put(:input, rest)

      number when is_integer(number) ->
        Map.put(acc, variable, number)
    end
  end

  def eval_instruction({op, a, b}, acc) do
    a_value = get_value(acc, a)
    b_value = get_value(acc, b)
    # IO.puts "#{a} = #{a}(#{inspect a_value}) #{op} #{b}(#{inspect b_value})"
    res =
      case op do
        :add -> a_value + b_value
        :mul -> a_value * b_value
        :div -> div(a_value, b_value)
        :mod -> Integer.mod(a_value, b_value)
        :eql -> if a_value == b_value, do: 1, else: 0
      end

    Map.put(acc, a, res)
  end

  defmodule Server do
    use GenServer
    def start_link do
      GenServer.start_link(__MODULE__, [])
    end
    def init([]) do
      :timer.send_interval(1000, :update)
      {:ok, nil}
    end
    def handle_info(:update, state) do
      IO.puts(:persistent_term.get(:current))
      {:noreply, state}
    end
  end

  def part_1 do
    # program = input_program()
    __MODULE__.Server.start_link()

    start_number = Integer.undigits(List.duplicate(9, 14))

    [res] = Stream.iterate(start_number, &(&1 - 1))
    |> Flow.from_enumerable()
    |> Flow.reject(&(0 in Integer.digits(&1)))
    |> Flow.map(fn num ->
      :persistent_term.put(:current, num)
      num
    end)
    |> Flow.filter(&Day24.Program.execute(Integer.digits(&1)))
    |> Enum.take(1)

    res
  end

  def valid_serial_number?(number, program) do
    acc = eval(program, Integer.digits(number))
    Map.get(acc, :z, 0) == 0
  end

  def get_value(acc, expr) do
    case expr do
      int when is_integer(int) -> int
      variable when is_atom(variable) -> Map.get(acc, variable, 0)
    end
  end
end
