defmodule Table.Components.Modal do
  use Table, :live_component

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(state: :closed)
      |> assign(room_name: nil)
      |> assign(type: :create) # availables types: :create, :join, :add_token
      |> assign(link: nil)
      |> assign(status: :not_sent)
    {:ok, socket}
  end

end
