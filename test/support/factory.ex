defmodule Exlivery.Factory do
  use ExMachina

  alias Exlivery.Types.Item
  alias Exlivery.Types.Order

  def user_factory do
    %{birthdate: "1991/09/09", cpf: "09876535362", email: "amy@nbc.com", id: "25cb98a6-9879-4af1-a423-5ceb840be600", name: "Amy Santiago"}
  end

  def item_factory do
    Item.build(
      "X-Burger",
      1,
      25.00,
      "Vegetarian hamburger made with fresh beens, tomatoes and chickpea",
      "without mayo"
    )
  end

  def order_factory do
    {:ok, user} = build(:user)

    {:ok, item} = build(:item)

    Order.build(user, "Brooklyn 99 St, 990", [item])
  end
end
