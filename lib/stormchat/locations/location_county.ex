defmodule Stormchat.Locations.LocationCounty do
  use Ecto.Schema
  import Ecto.Changeset

  schema "location_counties" do
    field :fips_code, :string
    belongs_to :location, Stormchat.Locations.Location

    timestamps()
  end

  @doc false
  def changeset(location_county, attrs) do
    location_county
    |> cast(attrs, [:fips_code, :location_id])
    |> validate_required([:fips_code, :location_id])
  end
end
