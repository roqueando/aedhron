defmodule Table.GridLive do
  use Table, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:players, [])
      |> assign(:tokens, [])
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    if connected?(socket), do: Table.subscribe(id)
    table = Warehouse.Table.get(id)
    socket =
      socket
      |> assign(:table_id, id)
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
    token |> Table.broadcast(:token_created, socket.assigns.table_id)

    send_update Table.Components.Modal, id: "modal-create", state: :closed
    {:noreply, socket}
  end

  @impl true
  def handle_info({:token_created, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | socket.assigns.tokens])}
  end
end
