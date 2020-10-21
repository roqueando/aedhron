defmodule Table.Components.Token do
  use Table, :live_component

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(name: nil)
      |> assign(type: :npc) # available: :npc, :monster, :player
      |> assign(status: %{ health: nil, mana: nil })
    {:ok, socket}
  end

end
