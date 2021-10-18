defmodule Exlivery.Types.Item do
  @moduledoc """
  Represents an item that will be used to make an order.
  """
  alias Exlivery.ItemAgent

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

  @spec create(
          name :: String,
          quantity :: integer(),
          unity_price :: String,
          description :: String
        ) :: {:ok, :item_created} | {:error, any()}
  def create(name, quantity, unity_price, description \\ "") do
    with {:ok, item} <- build(name, quantity, unity_price, description),
         {:ok} <- ItemAgent.save(item) do
      {:ok, :item_created}
    else
      error -> error
    end
  end

  @spec update(
          user_cpf :: String,
          data :: map()
        ) :: {:ok, data :: t()} | {:error, error :: atom()}
  def update(id, data) do
    with {:ok, item} <- ItemAgent.get(id),
         data <- Map.merge(data, item),
         {:ok, _item_updated} <- ItemAgent.save(data) do
      {:ok, data}
    else
      error -> error
    end
  end

  defp build(name, quantity, unity_price, description \\ "")

  defp build(name, quantity, unity_price, description)
       when is_integer(quantity) and is_binary(unity_price) do
    {:ok,
     %__MODULE__{
       id: UUID.uuid4(),
       name: name,
       quantity: quantity,
       unity_price: Decimal.new(unity_price),
       description: description
     }}
  end

  def total_price(unity_price, quantity), do: Decimal.mult(unity_price, quantity)
end
