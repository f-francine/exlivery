defmodule Exlivery.Types.Item do
  @moduledoc """
  Represents an item that will be used to make an order.
  """
  @enforce_keys [:name, :quantity, :price]

  defstruct [:id, :description, :details] ++ @enforce_keys

  @type t :: %__MODULE__{
          id: UUID,
          name: String,
          quantity: integer(),
          price: integer(),
          description: String,
          details: String
        }

  @spec build(
          name :: String,
          quantity :: integer(),
          price :: integer(),
          description :: String,
          details :: String
        ) :: {:ok, t()} | {:error, :invalid_params}
  def build(name, quantity, price, description \\ "", details \\ "") when is_integer(price) and is_integer(quantity)  do
   {:ok,  %__MODULE__{
      id: UUID.uuid4(),
      name: name,
      quantity: quantity,
      price: Decimal.cast(price),
      description: description,
      details: details
    }}
  end

  def build(_name, _quantity, _price, _description,  _details), do: {:error, :invalid_params}
end
