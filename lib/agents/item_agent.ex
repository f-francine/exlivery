defmodule Exlivery.ItemAgent do
  @moduledoc """
  Saves the user state.
  """
  use Agent

  alias Exlivery.Types.Item

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Item{} = item), do: Agent.update(__MODULE__, &update_state(&1, item))

  def get(id), do: Agent.get(__MODULE__, &get_item(&1, id))

  def update_state(state, %Item{id: id} = item), do: Map.put(state, id, item)

  defp get_item(state, id) do
    case Map.get(state, id) do
      nil -> {:error, :item_not_found}
      item -> {:ok, item}
    end
  end
end
