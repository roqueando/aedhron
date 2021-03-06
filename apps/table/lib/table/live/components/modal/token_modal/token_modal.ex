defmodule Table.Components.Modal.TokenModal do
  use Table, :live_component

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(state: :closed)
      |> assign(room_name: nil)
      |> assign(type: :add_token) # availables types: :create, :join, :add_token
      |> assign(link: nil)
    {:ok, socket}
  end

end
