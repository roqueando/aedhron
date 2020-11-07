defmodule Table.AuthLive do
  use Table, :live_view

  def mount(%{"key" => key}, session, socket) do
    session = 
      session
      |> Map.put("auth_key", key)

    #TODO: find a way to send to just `Table.GridLive` to update the session

    {:ok, assign(socket, :page_title, "ædhron - gates")}
  end
end
