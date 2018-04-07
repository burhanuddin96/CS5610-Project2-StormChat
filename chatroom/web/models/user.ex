defmodule Faster.User do
  use Faster.Web, :model
  alias Faster.Repo
  import Ecto.Changeset

  schema "users" do
    field :password, :string
    field :username, :string
    timestamps()
  end

  defp hashed_password(password), do: Cipher.encrypt(password)

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> unique_constraint(:username)
    |> validate_length(:username, min: 3, max: 15)
    |> validate_length(:password, min: 3, max: 15)
  end

  def authenticate(login) do
    login
    |> Map.split(["username", "password"])
    |> elem(0)
    |> Map.put("password", hashed_password(login["password"]))
    |> Enum.to_list
    |> Enum.map(fn {key, value} -> {String.to_atom(key), value} end)
    |> (&Repo.get_by(Faster.User, &1)).()
  end

  def hash_password(changeset) do
    password = changeset.params["password"]
    put_change(changeset, :password, hashed_password(password))
  end
end
