defmodule Stormchat.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    belongs_to :alerts, Stormchat.Alerts.Alert
    belongs_to :users, Stormchat.Users.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:body, :alert_id, :user_id])
    |> validate_required([:body, :alert_id, :user_id])
  end
end
