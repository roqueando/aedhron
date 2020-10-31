defmodule Table.TableLive do
  use Table, :live_view

  def mount(_params, _session, socket) do
    socket = 
      socket
      |> assign(:page_title, "ædhron")
    {:ok, socket}
  end

  def handle_event("create_table", %{"table" => table_params}, socket) do
    table = Warehouse.Table.create(table_params)
    url = "http://localhost:4000/t/#{table.id}"
    send_update Table.Components.Modal, 
      id: "modal-create", 
      link: url, 
      room_name: "#{table.name}@#{table.id}"

    {:noreply, socket}
  end
end
