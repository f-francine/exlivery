defmodule Exlivery.UserAgent do
  @moduledoc """
  Saves the user state.
  """
  use Agent

  alias Exlivery.Types.User

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save(%User{} = user), do: Agent.update(__MODULE__, &update_state(&1, user))

  def get(cpf), do: Agent.get(__MODULE__, &get_user(&1, cpf))

  def update_state(state, %User{cpf: cpf} = user), do: Map.put(state, cpf, user)

  defp get_user(state, cpf) do
    case Map.get(state, cpf) do
      nil -> {:error, :user_not_found}
      user -> {:ok, user}
    end
  end
end
