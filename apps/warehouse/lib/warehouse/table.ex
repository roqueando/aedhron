defmodule Warehouse.Table do
  use Memento.Table, attributes: [:id, :name, :max_players, :owner, :invites]
  alias Memento.Query

  @m __MODULE__

  def create(table_params) do
    Memento.transaction! fn ->
      Query.write(%@m{
        name: table_params["name"], 
        max_players: table_params["max_players"], 
        invites: table_params["max_players"],
        id: UUID.uuid4(),
        owner: table_params["owner"]
      })
    end
  end

  def all do
    Memento.transaction! fn ->
      Query.all(@m)
    end
  end

  def get(id) do
    Memento.transaction! fn ->
      Query.read(@m, id)
    end
  end

  def get_by_owner_and_id(key, table_id) do
    Memento.transaction! fn ->
      Query.select(@m, [
        {:==, :owner, key},
        {:==, :id, table_id}
      ])
    end
  end

  def consume_invite(table) do
    invites = if is_binary(table.invites), 
      do: String.to_integer(table.invites) - 1, 
      else: table.invites - 1
    updated = table
              |> Map.put(:invites, invites)

    Memento.transaction! fn ->
      Query.delete_record(table)
      Query.write(updated)
    end

    invites
  end
end
