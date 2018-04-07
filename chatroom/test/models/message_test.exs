defmodule Faster.MessageTest do
  alias Faster.Message
  use Faster.ModelCase

  @invldAttr %{}
  @vldAttr %{content: "some content"}

  test "Invalid attributes" do
    changeset = Message.changeset(%Message{}, @invldAttr)
    refute changeset.valid?
  end

  test "Valid attributes" do
    changeset = Message.changeset(%Message{}, @vldAttr)
    assert changeset.valid?
  end
end
