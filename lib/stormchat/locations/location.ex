defmodule Stormchat.Locations.Location do
  use Ecto.Schema
  import Ecto.Changeset

  schema "locations" do
    field :description, :string
    field :lat, :float
    field :long, :float
    belongs_to :user, Stormchat.Users.User

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:lat, :long, :description, :user_id])
    |> validate_required([:lat, :long, :description, :user_id])
  end
end
