defmodule Board.Repo.Migrations.CreateTopic do
  use Ecto.Migration

  def change do
    create table(:topics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :text, :text
      add :name, :text
      add :author_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:topics, [:author_id])
  end
end
