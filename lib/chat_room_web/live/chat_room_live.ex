defmodule ChatRoomWeb.ChatRoomLive do
  use ChatRoomWeb, :live_view

  @topic "chat_room"

  def mount(params, session, socket) do
    {:ok, assign(socket, :counter_value, 0)}
  end
end