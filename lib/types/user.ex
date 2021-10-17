defmodule Exlivery.Types.User do
  @moduledoc """
  Entity that can be used to order an item.
  """

  alias Exlivery.UserAgent

  @enforce_keys [:name, :email, :cpf, :birthdate]
  defstruct [:id] ++ @enforce_keys

  @type t :: %__MODULE__{
          id: UUID,
          name: String,
          email: String,
          cpf: String,
          birthdate: Date
        }

  @spec create(name :: String, email :: String, cpf :: String, birthdate :: String) ::
          {:ok, :user_created}
          | {:error, :invalid_cpf | :invalid_date_format | :invalid_email | :user_too_young}
  def create(name, email, cpf, birthdate) do
    with {:ok, user} <- build(name, email, cpf, birthdate),
         {:ok} <- UserAgent.save(user) do
      {:ok, :user_created}
    else
      error -> error
    end
  end

  @spec update(cpf :: String, data :: map()) :: {:ok, t()} | {:error, reason :: atom()}
  def update(cpf, data) do
    with {:ok, user} <- UserAgent.get(cpf),
         data <- Map.merge(data, user),
         {:ok, user_updated} = d <- UserAgent.save(data) do
      {:ok, data}
    else
      error -> error
    end
  end

  defp build(name, email, cpf, birthdate) do
    with {:ok, date} <- valid_birthdate?(birthdate),
         {:email, true} <- {:email, valid_email?(email)},
         {:ok, :ok} <- valid_cpf?(cpf) do
      {:ok,
       %__MODULE__{
         id: UUID.uuid4(),
         name: name,
         email: email,
         cpf: cpf,
         birthdate: date
       }}
    else
      {:email, false} -> {:error, :invalid_email}
      {:error, _reason} = error -> error
    end
  end

  defp valid_email?(email), do: Regex.match?(~r|.*@.*.com|, email)

  defp valid_birthdate?(birthdate) do
    with true <- valid_birthdate_format?(birthdate),
         {:ok, date} <- valid_user_age?(birthdate) do
      {:ok, date}
    else
      false -> {:error, :invalid_date_format}
      {:error, :user_too_young} = error -> error
    end
  end

  defp valid_birthdate_format?(birthdate), do: Regex.match?(~r|.?.?.?.?/.?.?/.?.?|, birthdate)

  defp valid_user_age?(birthdate) do
    [y, m, d] = Enum.map(String.split(birthdate, "/"), fn x -> String.to_integer(x) end)

    {:ok, date} = Date.new(y, m, d)
    user_age = Date.diff(Date.utc_today(), date) / 365

    if user_age >= 16, do: {:ok, date}, else: {:error, :user_too_young}
  end

  defp valid_cpf?(cpf) do
    if String.length(cpf) == 11, do: {:ok, :ok}, else: {:error, :invalid_cpf}
  end
end
