defmodule Stormchat.Alerts do
  @moduledoc """
  The Alerts context.
  """

  # http://davekuhlman.org/static/search_xml05.ex
  require Record
  Record.defrecord :xmlElement,
    Record.extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlText,
    Record.extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
  Record.defrecord :xmlAttribute,
    Record.extract(:xmlAttribute, from_lib: "xmerl/include/xmerl.hrl")

  import Ecto.Query, warn: false
  alias Stormchat.Repo

  alias Stormchat.Alerts.Alert



  def get_atom_feed() do
    resp = HTTPoison.get!("https://alerts.weather.gov/cap/us.php?x=0")
    xml_string = to_charlist(resp.body)
    {xml_doc, _rest} = :xmerl_scan.string(xml_string)
    xml_doc
  end

  def get_and_parse_atom_feed() do
    entries = :xmerl_xpath.string('//entry', get_atom_feed())
    maps = Enum.map(entries, fn (xe) -> xml_to_map(xe) end)
    Enum.each(maps, fn (mm) -> IO.inspect(mm) end)

    # :xmerl_xpath.string('//entry/title', get_atom_feed())
    # |> Enum.map(fn (xe) -> xmlElement(xe, :content) end)
    # |> Enum.map(fn ([{_, _, _, _, text, _}]) -> text end)
    # |> Enum.each(fn (tt) -> IO.puts(tt) end)
  end

  def xml_to_map(xml_entry) do
    xmlElement(xml_entry, :content)
    |> Enum.filter(fn(rr) -> Record.is_record(rr, :xmlElement) end)
    |> Enum.filter(fn(rr) -> Record.is_record(List.first(xmlElement(rr, :content)), :xmlText) end)
    |> Enum.reduce(%{}, fn (xe, acc) -> Map.put(acc, xmlElement(xe, :name), xmlText(List.first(xmlElement(xe, :content)), :value)) end)
  end


  @doc """
  Returns the list of alerts.

  ## Examples

      iex> list_alerts()
      [%Alert{}, ...]

  """
  def list_alerts do
    Repo.all(Alert)
  end

  @doc """
  Gets a single alert.

  Raises `Ecto.NoResultsError` if the Alert does not exist.

  ## Examples

      iex> get_alert!(123)
      %Alert{}

      iex> get_alert!(456)
      ** (Ecto.NoResultsError)

  """
  def get_alert!(id), do: Repo.get!(Alert, id)

  @doc """
  Creates a alert.

  ## Examples

      iex> create_alert(%{field: value})
      {:ok, %Alert{}}

      iex> create_alert(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alert(attrs \\ %{}) do
    %Alert{}
    |> Alert.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a alert.

  ## Examples

      iex> update_alert(alert, %{field: new_value})
      {:ok, %Alert{}}

      iex> update_alert(alert, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_alert(%Alert{} = alert, attrs) do
    alert
    |> Alert.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Alert.

  ## Examples

      iex> delete_alert(alert)
      {:ok, %Alert{}}

      iex> delete_alert(alert)
      {:error, %Ecto.Changeset{}}

  """
  def delete_alert(%Alert{} = alert) do
    Repo.delete(alert)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking alert changes.

  ## Examples

      iex> change_alert(alert)
      %Ecto.Changeset{source: %Alert{}}

  """
  def change_alert(%Alert{} = alert) do
    Alert.changeset(alert, %{})
  end

  alias Stormchat.Alerts.County

  @doc """
  Returns the list of counties.

  ## Examples

      iex> list_counties()
      [%County{}, ...]

  """
  def list_counties do
    Repo.all(County)
  end

  @doc """
  Gets a single county.

  Raises `Ecto.NoResultsError` if the County does not exist.

  ## Examples

      iex> get_county!(123)
      %County{}

      iex> get_county!(456)
      ** (Ecto.NoResultsError)

  """
  def get_county!(id), do: Repo.get!(County, id)

  @doc """
  Creates a county.

  ## Examples

      iex> create_county(%{field: value})
      {:ok, %County{}}

      iex> create_county(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_county(attrs \\ %{}) do
    %County{}
    |> County.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a county.

  ## Examples

      iex> update_county(county, %{field: new_value})
      {:ok, %County{}}

      iex> update_county(county, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_county(%County{} = county, attrs) do
    county
    |> County.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a County.

  ## Examples

      iex> delete_county(county)
      {:ok, %County{}}

      iex> delete_county(county)
      {:error, %Ecto.Changeset{}}

  """
  def delete_county(%County{} = county) do
    Repo.delete(county)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking county changes.

  ## Examples

      iex> change_county(county)
      %Ecto.Changeset{source: %County{}}

  """
  def change_county(%County{} = county) do
    County.changeset(county, %{})
  end
end
