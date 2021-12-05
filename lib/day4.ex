defmodule Day4 do
  @numbers [
    13,
    79,
    74,
    35,
    76,
    12,
    43,
    71,
    87,
    72,
    23,
    91,
    31,
    67,
    58,
    61,
    96,
    16,
    81,
    92,
    41,
    6,
    32,
    86,
    77,
    42,
    0,
    55,
    68,
    14,
    53,
    26,
    25,
    11,
    45,
    94,
    75,
    1,
    93,
    83,
    52,
    7,
    4,
    22,
    34,
    64,
    69,
    88,
    65,
    66,
    39,
    97,
    27,
    29,
    78,
    5,
    49,
    82,
    54,
    46,
    51,
    28,
    98,
    36,
    48,
    15,
    2,
    50,
    38,
    24,
    89,
    59,
    8,
    3,
    18,
    47,
    10,
    90,
    21,
    80,
    73,
    33,
    85,
    62,
    19,
    37,
    57,
    95,
    60,
    20,
    99,
    17,
    63,
    56,
    84,
    44,
    40,
    70,
    9,
    30
  ]

  @type board :: list(board_row())
  @type board_row :: list(number | {:marked, number})

  def boards do
    {boards, _} =
      __DIR__
      |> Path.join("day4.txt")
      |> File.stream!()
      |> Enum.reduce({[], []}, fn
        "\n", {boards, board} ->
          {[board | boards], []}

        line, {boards, board} ->
          line = for <<x::binary-size(3) <- line>>, do: x |> String.trim() |> String.to_integer()
          {boards, [line | board]}
      end)

    boards
  end

  def part_1 do
    {winning_board, number} = find_winning_board(@numbers, boards())
    score = board_score(winning_board)
    IO.puts("score: #{score}")
    IO.puts("number: #{number}")
    IO.puts("final score: #{score * number}")
  end

  def part_2 do
    {losing_board, numbers} = find_losing_board(@numbers, boards())
    {losing_board, number} = find_winning_board(numbers, [losing_board])
    score = board_score(losing_board)
    IO.puts("score: #{score}")
    IO.puts("number: #{number}")
    IO.puts("final score: #{score * number}")
  end

  @spec find_winning_board(list(number()), list(board())) :: {board(), number()}
  def find_winning_board(numbers, boards)

  def find_winning_board([next | numbers], boards) do
    boards = Enum.map(boards, &mark_number(&1, next))
    bingo_boards = Enum.filter(boards, &is_bingo?/1)

    case bingo_boards do
      [] -> find_winning_board(numbers, boards)
      [board] -> {board, next}
    end
  end

  @spec find_losing_board(list(number()), list(board())) :: {board(), [number()]}
  def find_losing_board(numbers, boards)
  def find_losing_board([next | numbers], boards) do
    boards = Enum.map(boards, &mark_number(&1, next))
    losing_boards = Enum.reject(boards, &is_bingo?/1)

    case losing_boards do
      [board] -> {board, numbers}
      _ -> find_losing_board(numbers, losing_boards)
    end
  end

  def board_score(board) do
    board
    |> List.flatten()
    |> Enum.reject(&is_marked?/1)
    |> Enum.sum()
  end

  def mark_number(board, number) do
    Enum.map(board, &mark_number_in_row(&1, number))
  end

  def mark_number_in_row(row, number) do
    Enum.map(row, &mark_number_in_cell(&1, number))
  end

  def mark_number_in_cell(cell, number) do
    if cell == number do
      {:marked, cell}
    else
      cell
    end
  end

  @spec is_bingo?(board()) :: boolean
  def is_bingo?(board) do
    any_row? =
      Enum.any?(board, fn row ->
        Enum.all?(row, &is_marked?/1)
      end)

    any_column? =
      Enum.reduce_while(0..4, false, fn index, _acc ->
        vertical_bingo? =
          Enum.all?(board, fn row ->
            is_marked?(Enum.at(row, index))
          end)

        if vertical_bingo?, do: {:halt, true}, else: {:cont, false}
      end)

    any_row? or any_column?
  end

  def is_marked?(number) do
    case number do
      {:marked, _} -> true
      _ -> false
    end
  end
end
