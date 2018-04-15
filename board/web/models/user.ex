defmodule Board.User do
  use Board.Web, :model
  alias Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :handle, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    has_many :posts, Board.Post, foreign_key: :author_id
    has_many :topics, Board.Topic, foreign_key: :author_id
    timestamps()
  end

  @doc """
  Registration changeset requires password and sets proper password hash
  """
  def registration_changeset(struct, params \\ %{}) do
   struct
   |> changeset(params)
   |> cast(params, [:password])
   |> validate_required([:password])
   |> validate_length(:password, min: 6)
   |> put_password_hash
 end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:handle, :email, :name, :password_hash])
    |> validate_required([:handle, :email])
    |> validate_length(:handle, min: 3, max: 25)
    |> validate_length(:email, min: 3, max: 255)
    |> validate_format(:handle, ~r/^[a-z0-9]+$/i)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:handle)
    |> unique_constraint(:email)
  end

 defp put_password_hash(changeset) do
   case changeset do
     %Ecto.Changeset{valid?: true, changes: %{password: password}} -> put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))
     _ -> changeset
   end
 end
end
