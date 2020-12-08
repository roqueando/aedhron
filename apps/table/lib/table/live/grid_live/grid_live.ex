defmodule Table.GridLive do
  use Table, :live_view

  alias Guard.Key

  @impl true
  def mount(_params, _session, socket) do
    Table.subscribe_app()
    socket = 
      socket
      |> assign(:players, [])
      |> assign(:dropdown_auth, false)
      |> assign(:auth_request, false)
      |> assign(:tokens, [])
      |> assign(:key, nil)
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "key" => key}, _uri, socket) do
    if connected?(socket), do: Table.subscribe(id)
    table = Warehouse.Table.get(id)
    socket =
      socket
      |> assign(:table_id, id)
      |> assign(:max_players, table.invites)
      |> assign(:page_title, "ædhron @ #{table.name}")
      |> assign(:table_name, table.name)
      |> assign(:key, key)
    {:noreply, socket}
  end

  @impl true
  def handle_params(%{"id" => id, "invite" => invite}, _uri, socket) do
    if connected?(socket), do: Table.subscribe(id)
    table = Warehouse.Table.get(id)
    socket =
      socket
      |> assign(:table_id, id)
      |> assign(:max_players, table.invites)
      |> assign(:page_title, "ædhron @ #{table.name}")
      |> assign(:table_name, table.name)
      |> assign(:invite, invite)
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
      moves: 6,
      avatar: token_params["image"]
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
  
  def handle_event("toggle_auth_down", _params, socket) do
    socket =
      socket
      |> assign(dropdown_auth: !socket.assigns.dropdown_auth)
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

  @impl true
  def handle_info({:update_session, session}, socket) do
    socket =
      socket
      |> assign(key: session["auth_key"])
      |> assign(auth_request: false)
    {:noreply, socket}
  end

  def validate_key(key, table_id) do
    Key.validate_auth_key(key, table_id)
  end

  def validate_invite(invite, table_id) do
    Key.validate_invite_key(invite, table_id)
  end
end
