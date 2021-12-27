defmodule Day23 do
  @type amphipod_type :: :a | :b | :c | :d
  @type amphipod_position ::
          {:room, for_amphipod :: amphipod_type, position :: 1 | 2}
          | {:hallway, position :: non_neg_integer()}
  @type amphipod :: {amphipod_type(), amphipod_position()}
  @type state :: [amphipod()]

  defmodule Struct do
    defstruct [:pods, :last_cost]
  end

  alias __MODULE__.Struct

  def example(), do: %Struct{
    pods: [
      {:b, {:room, :a, 1}},
      {:a, {:room, :a, 2}},
      {:c, {:room, :b, 1}},
      {:d, {:room, :b, 2}},
      {:b, {:room, :c, 1}},
      {:c, {:room, :c, 2}},
      {:d, {:room, :d, 1}},
      {:a, {:room, :d, 2}}
    ],
    last_cost: 0
  }

  def neighbors(state) do
    # for each amphipod, we can generate multiple mpvements
    for amphipod <- state.pods, neighbor <- get_moves_for_amphipod(amphipod, state) do
      neighbor
    end
  end

  def get_moves_for_amphipod(amphipod, state) do

  end

  def calc_moves(pod, state, acc \\ [], cost \\ 0)
  # this pod should never need to move, since it's in its final position
  def calc_moves({type, {:room, type, 2}}, _state, acc, cost), do: acc

  def move_pod(state, from, to) do

  end

  def room_pos(:a), do: 3
  def room_pos(:b), do: 5
  def room_pos(:c), do: 7
  def room_pos(:d), do: 9
end
