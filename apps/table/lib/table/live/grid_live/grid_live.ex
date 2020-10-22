defmodule Table.GridLive do
  use Table, :live_view

  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:players, [])
      |> assign(:tokens, [])
    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    table = Warehouse.Table.get(id)
    socket =
      socket
      |> assign(:table_name, table.name)
    {:noreply, socket}
  end

  def handle_event("create_token", %{"token" => token_params}, socket) do
    token = %{
      id: Warehouse.generate_id(),
      name: token_params["name"],
      status: %{
        health: 10,
        mana: 10
      },
      moves: 6
    }
    socket = 
      socket
      |> assign(:tokens, [token | socket.assigns.tokens])

    send_update Table.Components.Modal, id: "modal-create", state: :closed
    {:noreply, socket}
  end
end
