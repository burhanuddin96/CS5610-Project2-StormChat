defmodule Board.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    execute ~s(CREATE EXTENSION IF NOT EXISTS "citext")

    create table(:users, primary_key: false) do
      add :name, :string
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :handle, :citext, null: false
      add :password_hash, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:handle])
    
  end
end
