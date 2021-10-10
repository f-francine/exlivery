defmodule Exlivery.Factory do
  use ExMachina

  alias Exlivery.Types.Item
  alias Exlivery.Types.Order

  def user_factory do
    %{
      birthdate: "1991/09/09",
      cpf: "09876535362",
      email: "amy@nbc.com",
      id: "25cb98a6-9879-4af1-a423-5ceb840be600",
      name: "Amy Santiago"
    }
  end

  def item_factory do
    %{
      description: "Vegetarian hamburger made with fresh beens, tomatoes and chickpea",
      details: "without mayo",
      id: "27aaf001-ec50-45de-82f6-a976f7501547",
      name: "X-Burger",
      quantity: 1,
      unity_price: Decimal.new("25.00")
    }
  end

  def order_factory do
    {:ok, user} = build(:user)

    {:ok, item} = build(:item)

    Order.build(user, "Brooklyn 99 St, 990", [item])
  end
end
