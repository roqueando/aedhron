defmodule Table.Components.Modal.InviteModal do
  use Table, :live_component

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign(invite_count: 1)
      |> assign(type: :create) # availables types: :create, :join, :add_token
    {:ok, socket}
  end

  @impl true
  def handle_event("invite_players", %{"invite" => invite}, socket) do

    if String.to_integer(socket.assigns.max_uses) == 0 do
      IO.inspect('max uses reached')
      {:noreply, socket}
    else
      max_uses = String.to_integer(socket.assigns.max_uses) - 1
      Hermes.Email.invite_email(invite["email"], "Table Test", "http://localhost:4000/")
      socket = 
        socket
        |> assign(:max_uses, Integer.to_string(max_uses))
      {:noreply, socket}
    end
  end

end
