defmodule Exlivery do
  def init(_) do
    Exlivery.UserAgent.start_link(%{})
    Exlivery.OrderAgent.start_link(%{})
  end
end
