defmodule Table.Components.Modal.InviteModal do
  use Table, :live_component

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(type: :create) # availables types: :create, :join, :add_token
    {:ok, socket}
  end

end
