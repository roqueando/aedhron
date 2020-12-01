defmodule Table.Components.Modal.InviteModal do
  use Table, :live_component

  alias Warehouse.Invite
  alias Warehouse.Table, as: WTable

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(invite_count: 1)
      |> assign(max_used: false)
      |> assign(type: :create) # availables types: :create, :join, :add_token
    {:ok, socket}
  end

  @impl true
  def handle_event("invite_players", %{"invite" => invite}, socket) do

    if socket.assigns.max_uses === 0 do
      {:noreply, assign(socket, :max_used, true)}
    else
      current_invites = WTable.consume_invite(WTable.get(socket.assigns.table_id))
      if current_invites === 0, do: assign(socket, :max_used, true)

      generate_key_and_invite(invite["email"], socket.assigns.table_name, socket.assigns.table_id)

      socket = 
        socket
        |> assign(:max_uses, current_invites)
        |> assign(:max_players, current_invites)
      {:noreply, socket}
    end
  end

  defp create_invite(key, table_id), do: Invite.create(%{ "key" => key, "reference" => table_id })

  defp generate_key_and_invite(email, table_name, table_id) do
    {:ok, key} = Guard.Key.generate_authenticate_key(email)
    create_invite(key, table_id)
    Hermes.Email.invite_email(email, table_name, table_id, key)
  end

end
