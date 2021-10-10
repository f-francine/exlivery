defmodule Exlivery.Types.Order do
  @moduledoc """
  Represents an order that will be make by the user.
  """

  alias Exlivery.Types.Item
  alias Exlivery.Types.User

  @enforce_keys [:user_cpf, :delivery_address, :items, :total_price]

  defstruct [:id] ++ @enforce_keys

  @type t :: %__MODULE__{
          id: UUID,
          user_cpf: String,
          delivery_address: String,
          items: List,
          total_price: integer()
        }

  @spec build(
          user_cpf :: String,
          delivery_address :: String,
          items :: List
        ) :: {:ok, t()} | {:error, :invalid_params}
  def build(%User{cpf: cpf}, delivery_address, [%Item{} | _] = items) do
    {:ok,
     %__MODULE__{
       id: UUID.uuid4(),
       user_cpf: cpf,
       delivery_address: delivery_address,
       items: items,
       total_price: total_price(items)
     }}
  end

  def build(_user_cpf, _delivery_address, _items), do: {:error, :invalid_params}

  defp total_price(items), do: Enum.reduce(items, Decimal.new("0.00"), &sum_prices/2)

  defp sum_prices(%Item{unity_price: unity_price, quantity: quantity}, acc),
    do: Decimal.add(Item.total_price(unity_price, quantity), acc)
end
