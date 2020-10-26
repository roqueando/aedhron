defmodule Table.Components.Dice do
  use Table, :live_component

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("roll", %{"dice" => dice}, socket) do

    dice = String.to_integer(dice)
    result = Enum.random(1..dice)
    send_update Table.Components.DiceResult, id: "dice_result", state: :show, dice: "d#{dice}", result: result
    {:noreply, socket}
  end

end
