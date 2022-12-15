defmodule ChatRoomWeb.ChatRoomLive do
  use ChatRoomWeb, :live_view

  @topic "chat_room"

  def mount(params, session, socket) do
    ChatRoomWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, messages: [%{name: "SYS", msg: "Welcome to the chat room!"}], current_user: '')}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center justify-center w-screen min-h-screen bg-gray-100 text-gray-800 p-6">

        <!-- Component Start -->
        <div class="flex flex-col flex-grow w-full max-w-[75%] bg-white shadow-xl rounded-lg overflow-hidden mb-10">
          <div class="flex flex-col flex-grow h-0 p-4 overflow-auto">
            <!-- Loop over all messages -->
            <%= for message <- @messages do %>
            <div class="flex w-full mt-2 space-x-3 max-w-xs ml-auto justify-end">
                <div>
                    <div class="bg-blue-600 text-white p-3 rounded-l-lg rounded-br-lg">
                        <p class="text-sm"><%= message.msg %></p>
                    </div>
                </div>
                <div class="flex items-center justify-center h-10 w-10 rounded-full bg-gray-400 flex-shrink-0">
                    <span class="text-white
                        text-sm font-medium leading-none">
                        <%= message.name %>
                    </span>
                </div>
              </div>
            <%= end %>
          </div>
              <form phx-submit="send_message" class="flex justify-around bg-gray-300 p-4 gap-2">
                  <input type="text" name="name" value={@current_user} class="form-control flex h-10 w-2/6 rounded px-3 border-none text-sm" placeholder="Name" style="border: 1px black solid; font-size: 1.3em;" autofocus>
                  <input type="text" name="msg" class="form-control flex  h-10 w-4/6 rounded px-3 border-none text-sm" placeholder="Messages" style="border: 1px black solid; font-size: 1.3em;">
                  <button type="submit" class="w-1/6 rounded bg-indigo-300">Send</button>
              </form>
          </div>
        </div>
    """
  end

  def handle_event("send_message",%{"name" => name, "msg" => msg }, socket) do
    #send only initial of name to other users and safe full name in current_user
    current_user = name
    name = name
    |> String.split(" ")
    |> Enum.map(fn n -> String.upcase(String.at(n, 0)) end)
    |> Enum.join("")

    # append new message to messages
    new_payload = %{name: name, msg: msg}
    new_message = socket.assigns.messages ++ [new_payload]

    # broadcast new message to all users
    ChatRoomWeb.Endpoint.broadcast_from(self(), @topic,
      "chat_room_event",
      new_message)
    # assign new values to socket
    {:noreply, assign(socket, messages: new_message, current_user: current_user)}
  end

  def handle_info( %{topic: @topic, payload: new_messages}, socket ) do
    {:noreply, assign(socket, :messages, new_messages)}
  end

end