defmodule PairWeb.ChallengeView do
  use PairWeb, :view

  def titleize(string) do
    string
    |> String.split()
    |> Stream.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
