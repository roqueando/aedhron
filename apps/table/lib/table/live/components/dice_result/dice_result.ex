defmodule Table.Components.DiceResult do
  use Table, :live_component

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(:dice, "")
      |> assign(:state, :hidden) #availables: :show, :hidden
      |> assign(:result, nil)
    {:ok, socket}
  end


end
