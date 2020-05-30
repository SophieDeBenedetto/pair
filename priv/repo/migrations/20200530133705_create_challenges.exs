defmodule Pair.Repo.Migrations.CreateChallenges do
  use Ecto.Migration

  def change do
    create table(:challenges) do
      add :title, :string
      add :prompt, :text
      add :body, :text
      add :language, :string

      timestamps()
    end

  end
end
