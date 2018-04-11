defmodule Stormchat.Locations do
  @moduledoc """
  The Locations context.
  """

  import Ecto.Query, warn: false
  alias Stormchat.Repo

  alias Stormchat.Locations.Location

  def get_fips_by_latlong(lat, long) do
    base_path = "http://www.datasciencetoolkit.org/coordinates2politics/"
    url = base_path <> Float.to_string(lat) <> "%2c" <> Float.to_string(long)

    {msg, resp} = HTTPoison.get(url)

    case msg do
      :error ->
        IO.puts("http error getting fips from datasciencetoolkit api")
        IO.inspect(resp)
        get_fips_by_latlong(lat, long)
      :ok ->
        {m, r} = Poison.decode(resp.body)

        IO.inspect(r)

        case m do
          :error ->
            IO.puts("error decoding datascience toolkit fips jason response")
            IO.inspect(r)
          :ok ->
            [first | _rest] = r
            Enum.filter(first["politics"], fn(pp) -> pp["type"] == "admin6" end)
            |> Enum.map(fn(pp) -> "0" <> String.replace(pp["code"], "_", "") end)
        end
    end
  end


  @doc """
  Returns the list of locations.

  ## Examples

      iex> list_locations()
      [%Location{}, ...]

  """
  def list_locations do
    Repo.all(Location)
  end

  @doc """
  Gets a single location.

  Raises `Ecto.NoResultsError` if the Location does not exist.

  ## Examples

      iex> get_location!(123)
      %Location{}

      iex> get_location!(456)
      ** (Ecto.NoResultsError)

  """
  def get_location!(id), do: Repo.get!(Location, id)

  @doc """
  Creates a location.

  ## Examples

      iex> create_location(%{field: value})
      {:ok, %Location{}}

      iex> create_location(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a location.

  ## Examples

      iex> update_location(location, %{field: new_value})
      {:ok, %Location{}}

      iex> update_location(location, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Location.

  ## Examples

      iex> delete_location(location)
      {:ok, %Location{}}

      iex> delete_location(location)
      {:error, %Ecto.Changeset{}}

  """
  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking location changes.

  ## Examples

      iex> change_location(location)
      %Ecto.Changeset{source: %Location{}}

  """
  def change_location(%Location{} = location) do
    Location.changeset(location, %{})
  end
end
