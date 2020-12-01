defmodule Table.AuthLive do
  use Table, :live_view

  @impl true
  def mount(%{"key" => key}, session, socket) do
    session = 
      session
      |> Map.put("auth_key", key)

    Table.update_session(session, :update_session) 
    {:ok, assign(socket, :page_title, "ædhron - gates")}
  end
end
