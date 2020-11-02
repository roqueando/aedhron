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
      |> assign(:max_players, table.max_players)
      |> assign(:page_title, "ædhron @ #{table.name}")
      |> assign(:table_name, table.name)
    {:noreply, socket}
  end

  def handle_event("create_token", %{"token" => token_params}, socket) do
    token = %{
      id: Warehouse.generate_id(),
      name: token_params["name"],
      type: :npc,
      status: %{
        health: 10,
        mana: 10
      },
      position: %{
        x: 0,
        y: 0
      },
      moves: 6
    }
    token |> Table.broadcast(:token_created, socket.assigns.table_id)

    send_update Table.Components.Modal, id: "modal-create", state: :closed
    {:noreply, socket}
  end

  def handle_event("move_token", %{"position" => position, "id" => id}, socket) do
    token =
      socket.assigns.tokens
      |> Enum.find(fn map -> map.id == id end)
      |> Map.put(:position, %{
        x: position["x"],
        y: position["y"]
      })

    token |> Table.broadcast(:token_moved, socket.assigns.table_id)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:token_created, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | socket.assigns.tokens])}
  end

  @impl true
  def handle_info({:token_moved, token}, socket) do
    
    tokens = socket.assigns.tokens
             |> Enum.filter(fn map -> map.id != token.id end)

    {:noreply, assign(socket, :tokens, [token | tokens])}
  end

  @impl true
  def handle_info({:dice_result, roll}, socket) do
    send_update Table.Components.DiceResult, 
      id: "dice_result",
      dice: roll.dice,
      result: roll.result
    {:noreply, socket}
  end
end
