defmodule Exlivery.Types.ItemTest do
  @moduledoc false

  use ExUnit.Case

  alias Exlivery.Types.Item

  import Exlivery.Factory

  doctest Item

  setup do
    build(:item)
  end

  test "when all params are valid, creates an item", ctx do
    response = build(:item)

    assert response =
             Item.build(ctx.name, ctx.quantity, ctx.unity_price, ctx.description, ctx.details)
  end

  test "should return an error when quantity is not a number", ctx do
    quantity = "one"

    assert {:error, :invalid_params} =
             Item.build(ctx.name, quantity, ctx.unity_price, ctx.description, ctx.details)
  end

  test "should return an error when unity price is not a string", ctx do
    unity_price = 25.00

    assert {:error, :invalid_params} =
             Item.build(ctx.name, ctx.quantity, unity_price, ctx.description, ctx.details)
  end
end
