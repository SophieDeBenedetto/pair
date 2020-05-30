defmodule Pair.Challenge do
  use Ecto.Schema
  import Ecto.Changeset

  schema "challenges" do
    field :body, :string
    field :language, :string
    field :prompt, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(challenge, attrs) do
    challenge
    |> cast(attrs, [:title, :prompt, :body, :language])
    |> validate_required([:title, :prompt])
  end
end
