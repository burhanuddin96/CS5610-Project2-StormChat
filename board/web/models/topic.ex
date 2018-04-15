defmodule Board.Topic do
  use Board.Web, :model

  schema "topics" do
    field :text, :string
    field :name, :string
    has_many :posts, Board.Post
    belongs_to :author, Board.User
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :text])
    |> validate_required([:name, :text])
  end
end
