defmodule Exlivery.Types.Order do
  @moduledoc """
  Represents an order that will be make by the user.
  """

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
          items :: List,
          total_price :: integer()
        ) :: {:ok, t()} | {:error, :invalid_params}
  def build(user_cpf, delivery_address, items, total_price) when is_integer(total_price) do
    {:ok, %__MODULE__{
      id: UUID.uuid4(),
      user_cpf: user_cpf,
      delivery_address: delivery_address,
      items: items,
      total_price: Decimal.cast(total_price)
    }}
  end

  def build(_user_cpf, _delivery_address, _items, _total_price), do: {:error, :invalid_params}
end
