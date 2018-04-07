defmodule Faster.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :content, :string
      add :user, :string

      timestamps()
    end    

  end
end
