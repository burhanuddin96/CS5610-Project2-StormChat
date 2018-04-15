defmodule Board.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :topic_id, references(:topics, on_delete: :nothing, type: :binary_id), null: false
      add :text, :text
      add :author_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:posts, [:author_id])
    create index(:posts, [:topic_id])
    
  end
end
