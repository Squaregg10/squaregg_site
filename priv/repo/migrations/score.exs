defmodule SquareggSite.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :user, :string
      add :score, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
