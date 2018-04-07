defmodule Faster.UserTest do
  alias Faster.User
  use Faster.ModelCase

  @invldAttr %{}
  @vldAttr %{password: "some content", username: "some content"}

  test "Invalid attributes" do
    changeset = User.changeset(%User{}, @invldAttr)
    refute changeset.valid?
  end

  test "Valid attributes" do
    changeset = User.changeset(%User{}, @vldAttr)
    assert changeset.valid?
  end
end
