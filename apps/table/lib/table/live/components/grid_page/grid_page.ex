defmodule Table.Components.GridPage do
  use Table, :live_component

  @impl true
  def mount(socket) do
    IO.inspect(socket.assigns)
    {:ok, socket}
  end

  def handle_params(_params, _uri, socket) do
    IO.inspect(socket)
    {:ok, socket}
  end

  def component_id, do: Warehouse.generate_id
end
