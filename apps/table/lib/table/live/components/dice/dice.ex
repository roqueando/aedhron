defmodule Table.Components.Dice do
  use Table, :live_component

  alias Table.Roll

  @impl true
  def mount(socket) do
    socket = 
      socket
      |> assign(:rolls, [])
    {:ok, socket}
  end

  @impl true
  def handle_event("roll", %{"dice" => dice, "table_id" => table_id}, socket) do
    dice = String.to_integer(dice)
    result = Enum.random(1..dice)

    roll = %Roll{ dice: "d#{dice}", result: result }

    Table.broadcast(roll, :dice_result, table_id)

    {:noreply, assign(socket, :rolls, [roll | socket.assigns.rolls])}
  end


end
