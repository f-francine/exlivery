defmodule Exlivery.Types.Order do
  @moduledoc """
  Represents an order that will be make by the user.
  """

  alias Exlivery.Types.Item
  alias Exlivery.Types.User
  alias Exlivery.OrderAgent

  @enforce_keys [:user_cpf, :delivery_address, :items, :total_price]

  defstruct [:id] ++ @enforce_keys

  @type t :: %__MODULE__{
          id: UUID,
          user_cpf: String,
          delivery_address: String,
          items: List,
          total_price: integer()
        }

  @spec create(
          user_cpf :: String,
          delivery_address :: String,
          items :: List
        ) :: {:ok, :user_created} | {:error, :invalid_params}
  def create(%User{cpf: user_cpf}, delivery_address, [%Item{} | _] = items) do
    with {:ok, order} <- build(user_cpf, delivery_address, items),
         {:ok} <- OrderAgent.save(order) do
      {:ok, :user_created}
    else
      error -> error
    end
  end

  @spec update(
    user_cpf :: String,
    data :: map()
  ) :: {:ok, data :: t()} | {:error, :invalid_params}
  def update(%User{cpf: user_cpf}, data) do
    with {:ok, order} <- OrderAgent.get(user_cpf),
         data <- Map.merge(data, order),
         {:ok, _order_updated} <- OrderAgent.save(data) do
      {:ok, data}
    else
      error -> error
    end
  end

  defp build(user_cpf, delivery_address, [%Item{} | _] = items) do
    {:ok,
     %__MODULE__{
       id: UUID.uuid4(),
       user_cpf: user_cpf,
       delivery_address: delivery_address,
       items: items,
       total_price: total_price(items)
     }}
  end

  defp build(_user_cpf, _delivery_address, _items), do: {:error, :invalid_params}

  def total_price(items), do: Enum.reduce(items, Decimal.new("0.00"), &sum_prices/2)

  def sum_prices(%Item{unity_price: unity_price, quantity: quantity}, acc),
    do: Decimal.add(Item.total_price(unity_price, quantity), acc)
end
