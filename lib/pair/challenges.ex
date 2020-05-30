defmodule Pair.Challenges do
  alias Pair.{Challenge, Repo}

  def create_challenge(attrs) do
    %Challenge{}
    |> Challenge.changeset(attrs)
    |> Repo.insert!()
  end

  def get_challenges do
    Repo.all(Challenge)
  end
end
