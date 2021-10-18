defmodule Exlivery.OrderAgent do
  @moduledoc """
  Saves the user state.
  """
  use Agent

  alias Exlivery.Types.Order

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%Order{} = order), do: Agent.update(__MODULE__, &update_state(&1, order))

  def get(user_cpf), do: Agent.get(__MODULE__, &get_order(&1, user_cpf))

  def update_state(state, %Order{user_cpf: user_cpf} = order), do: Map.put(state, user_cpf, order)

  defp get_order(state, user_cpf) do
    case Map.get(state, user_cpf) do
      nil -> {:error, :order_not_found}
      order -> {:ok, order}
    end
  end
end
