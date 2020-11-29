defmodule Warehouse.Invite do
  use Memento.Table, attributes: [:id, :key, :reference]

  alias Memento.Query
  @m __MODULE__

  def create(invite_params) do
    Memento.transaction! fn ->
      Query.write(%@m{
        key: invite_params["key"], 
        id: UUID.uuid4(),
        reference: invite_params["reference"]
      })
    end
  end

  def all do
    Memento.transaction! fn -> Query.all(@m) end
  end

  def get(id) do
    Memento.transaction! fn -> Query.read(@m, id) end
  end

  def get_by_table(table_id, key) do
    Memento.transaction! fn ->
      Query.select(@m, [
        {:==, :reference, table_id},
        {:==, :key, key}
      ])
      |> List.first
    end
  end

end
