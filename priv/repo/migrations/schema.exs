defmodule SquareggSite.Repo.Migrations.CreateSchema do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :user, :string
      add :score, :integer

      timestamps(type: :utc_datetime)
    end

    create table(:chat) do
      add :user, :string
      add :message, :string

      timestamps(type: :utc_datetime)
    end
  end
end
