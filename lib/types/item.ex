defmodule Exlivery.Types.Item do
  @moduledoc """
  Represents an item that will be used to make an order.
  """
  @enforce_keys [:name, :quantity, :unity_price]

  defstruct [:id, :description, :details] ++ @enforce_keys

  @type t :: %__MODULE__{
          id: UUID,
          name: String,
          quantity: integer(),
          unity_price: integer(),
          description: String,
          details: String
        }

  @spec build(
          name :: String,
          quantity :: integer(),
          unity_price :: String,
          description :: String,
          details :: String
        ) :: {:ok, t()} | {:error, :invalid_params}

  def build(name, quantity, unity_price, description \\ "", details \\ "")

  def build(name, quantity, unity_price, description, details)
      when is_integer(quantity) and is_binary(unity_price) do
    {:ok,
     %__MODULE__{
       id: UUID.uuid4(),
       name: name,
       quantity: quantity,
       unity_price: Decimal.new(unity_price),
       description: description,
       details: details
     }}
  end

  def build(_name, _quantity, _price, _description, _details), do: {:error, :invalid_params}

  def total_price(unity_price, quantity), do: Decimal.mult(unity_price, quantity)
end
