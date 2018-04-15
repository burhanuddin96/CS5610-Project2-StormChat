defmodule Board.Post do
  use Board.Web, :model

  schema "posts" do
    field :text, :string
    belongs_to :author, Board.User
    belongs_to :topic, Board.Topic
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:text])
    |> validate_required([:text])
  end
end
