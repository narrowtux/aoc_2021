defmodule Day16 do
  use Bitwise

  def part_1(input) do
    {packets, _rest} = parse(input)
    add_versions(packets)
  end

  def add_versions(packets, acc \\ 0)
  def add_versions([], acc) do
    acc
  end
  def add_versions([{version, type, sub} | rest], acc) do
    acc = acc + version
    case type do
      :literal -> add_versions(rest, acc)
      _ ->
        acc = add_versions(sub, acc)
        add_versions(rest, acc)
    end
  end

  def part_2(input) do
    {packets, _rest} = parse(input)
    Enum.map(packets, &eval/1)
  end

  def eval({_, :literal, literal}), do: literal
  def eval({_, type, sub}) when type in ~w[sum product min max]a do
    values = Enum.map(sub, &eval/1)
    apply(Enum, type, [values])
  end

  def eval({_, type, sub}) when type in ~w[greater less equal]a do
    op = case type do
      :greater -> :>
      :less -> :<
      :equal -> :==
    end
    values = Enum.map(sub, &eval/1)
    case apply(Kernel, op, values) do
      true -> 1
      false -> 0
    end
  end

  def parse(input, acc \\ [], remaining \\ :infinity)

  def parse(rest, acc, _) when bit_size(rest) <= 7 do
    {Enum.reverse(acc), rest}
  end

  def parse(rest, acc, 0) do
    {Enum.reverse(acc), rest}
  end

  def parse(<<version::integer-3, type::integer-3, rest::bitstring>>, acc, remaining) when remaining != 0
      when bit_size(rest) >= 5 do
    {packet, rest} = parse_payload(version, type, rest)
    parse(rest, [packet | acc], dec(remaining))
  end


  def parse(rest, acc, _rem) do
    {Enum.reverse(acc), rest}
  end

  def dec(:infinity), do: :infinity
  def dec(remaining), do: remaining - 1

  def parse_payload(version, type, input) do
    {decoded, rest} =
      case type do
        4 -> decode_literal(input)
        _ -> decode_operator(input)
      end

    {{version, decode_opcode(type), decoded}, rest}
  end

  def decode_literal(input, acc \\ 0)

  def decode_literal(<<1::1, part::4, rest::bitstring>>, acc) do
    decode_literal(rest, (acc <<< 4) + part)
  end

  def decode_literal(<<0::1, part::4, rest::bitstring>>, acc) do
    {(acc <<< 4) + part, rest}
  end

  def decode_operator(<<0::1, length::15, rest::bitstring>>) do
    <<operator_payload::bitstring-size(length), other_packets::bitstring>> = rest
    {packets, ""} = parse(operator_payload)
    {packets, other_packets}
  end
  def decode_operator(<<1::1, count::11, rest::bitstring>>) do
    parse(rest, [], count)
  end

  def decode_opcode(opcode) do
    case opcode do
      0 -> :sum
      1 -> :product
      2 -> :min
      3 -> :max
      4 -> :literal
      5 -> :greater
      6 -> :less
      7 -> :equal
    end
  end
end
