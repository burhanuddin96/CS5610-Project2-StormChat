defmodule Faster.Message do
  alias Faster.{Message, Repo}
  use Faster.Web, :model

  schema "messages" do
    field :user, :string
    field :content, :string
    timestamps()
  end

  def create(payload_params) do
    changeset(%Message{}, payload_params)
    |> Repo.insert!
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :user])
    |> validate_required([:content, :user])
    |> validate_length(:content, min: 1)
  end

  def all do
    Message
    |> order_by(:inserted_at)
    |> Repo.all
  end
end
