defmodule ExliveryTest do
  use ExUnit.Case

  alias Exlivery.Types.User
  doctest User

  setup do
    %{name: "Amy Santiago", email: "amy@nbc.com", cpf: "98909076545", birthdate: "1991/09/09"}
  end

  test "when all params are valid, creates an user", ctx do
    assert {:ok,
            %Exlivery.Types.User{
              birthdate: ~D[1991-09-09],
              cpf: "98909076545",
              email: "amy@nbc.com",
              name: "Amy Santiago"
            }} = User.build(ctx.name, ctx.email, ctx.cpf, ctx.birthdate)
  end

  test "should return an error when user age is less then 16", ctx do
    birthdate = "2009/09/09"

    assert {:error, :user_too_young} = User.build(ctx.name, ctx.email, ctx.cpf, birthdate)
  end

  test "should return an error when cpf is invalid", ctx do
    cpf = "123"

    assert {:error, :invalid_cpf} = User.build(ctx.name, ctx.email, cpf, ctx.birthdate)
  end

  test "should return an error when email is invalid", ctx do
    email = "amy@nbc"

    assert {:error, :invalid_email} = User.build(ctx.name, email, ctx.cpf, ctx.birthdate)
  end
end
