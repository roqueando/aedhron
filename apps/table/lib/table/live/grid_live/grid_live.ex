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
end
