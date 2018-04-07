defmodule Faster.ChatChannelTest do
  alias Faster.ChatChannel
  use Faster.ChannelCase

  test "Status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(ChatChannel, "chat:lobby")
    {:ok, socket: socket}
  end

  test "Broadcasts pushed", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end

  test "shout broadcasts", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end
end
