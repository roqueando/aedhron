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
      |> assign(:invite, nil)
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
        full_h: 10,
        full_m: 10,
        mana: 10
      },
      position: %{
        x: 0,
        y: 0
      },
      moves: 6,
      dead: false,
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

  def handle_event("status_token", %{ "token_id" => token_id, "value" => value, "type" => type }, socket) do
    token = socket.assigns.tokens
            |> Enum.find(fn map -> map.id == token_id end)
    case type do
      "damage" ->
        damage_token(token, value, socket)
      "heal" ->
        heal_token(token, value, socket)
      "consume_mana" ->
        consume_token(token, value, socket)
      "restore_mana" ->
        restore_token(token, value, socket)
    end
    {:noreply, socket}
  end

  @impl true
  def handle_info({:token_created, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | socket.assigns.tokens])}
  end

  @impl true
  def handle_info({:token_moved, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | tokens(token, socket)])}
  end

  @impl true
  def handle_info({:token_dead, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | tokens(token, socket)])}
  end

  @impl true
  def handle_info({:token_damaged, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | tokens(token, socket)])}
  end

  @impl true
  def handle_info({:token_healed, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | tokens(token, socket)])}
  end

  @impl true
  def handle_info({:token_consumed, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | tokens(token, socket)])}
  end

  @impl true
  def handle_info({:token_restored, token}, socket) do
    {:noreply, assign(socket, :tokens, [token | tokens(token, socket)])}
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

  defp damage_token(token, value, socket) do
    sub = token.status.health - String.to_integer(value)
    current_h = if sub < 0, do: 0, else: sub
    cond do
      token.status.health <= 0 -> 
        token
        |> Map.put(:dead, true)
        |> Table.broadcast(:token_dead, socket.assigns.table_id)
      token.status.health > 0 ->
        token
        |> Map.put(:status, %{
          health: current_h,
          full_h: token.status.full_h,
          full_m: token.status.full_m,
          mana: token.status.mana
        })
        |> Table.broadcast(:token_damaged, socket.assigns.table_id)
    end
  end

  defp heal_token(token, value, socket) do
    sum = token.status.health + String.to_integer(value)
    current_h = if sum > token.status.full_h, do: token.status.full_h, else: sum
    cond do
      token.status.health > token.status.full_h ->
        {:ok}
      token.status.health != token.status.full_h ->
        token
        |> Map.put(:status, %{
          health: current_h,
          full_h: token.status.full_h,
          full_m: token.status.full_m,
          mana: token.status.mana
        })
        |> Table.broadcast(:token_healed, socket.assigns.table_id)
    end
  end

  defp consume_token(token, value, socket) do
    sub = token.status.mana - String.to_integer(value)
    current_m = if sub < 0, do: 0, else: sub
    cond do
      token.status.mana <= 0 -> 
        {:ok}
      token.status.mana > 0 ->
        token
        |> Map.put(:status, %{
          health: token.status.health,
          full_h: token.status.full_h,
          full_m: token.status.full_m,
          mana: current_m
        })
        |> Table.broadcast(:token_consumed, socket.assigns.table_id)
    end
  end

  defp restore_token(token, value, socket) do
    sum = token.status.mana + String.to_integer(value)
    current_m = if sum > token.status.full_m, do: token.status.full_m, else: sum
    cond do
      token.status.mana > token.status.full_h -> 
        {:ok}
      token.status.mana != token.status.full_h ->
        token
        |> Map.put(:status, %{
          health: token.status.health,
          full_h: token.status.full_h,
          full_m: token.status.full_m,
          mana: current_m
        })
        |> Table.broadcast(:token_restored, socket.assigns.table_id)
    end
  end

  defp tokens(token, socket) do
    socket.assigns.tokens
    |> Enum.filter(fn map -> map.id != token.id end)
  end
end
