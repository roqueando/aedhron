defmodule Table.TableLive do
  use Table, :live_view

  alias Guard.Key

  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:page_title, "ædhron")
    {:ok, socket}
  end

  def handle_event("create_table", %{"table" => table_params}, socket) do
    {:ok, key} = Key.generate_authenticate_key(table_params["email"])

    Hermes.Email.create_adventure(table_params, key)

    send_update Table.Components.Modal, id: "modal-create", status: :sent

    {:noreply, socket}
  end
end
