defmodule Table.Components.Modal do
  use Table, :live_component

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(state: :closed)
      |> assign(room_name: nil)
      |> assign(link: nil)
    {:ok, socket}
  end

end
