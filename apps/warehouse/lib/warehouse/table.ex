defmodule Warehouse.Table do
  use Memento.Table, attributes: [:id, :name, :max_players]
  alias Memento.Query

  def create(table_params) do
    Memento.transaction! fn ->
      Query.write(%__MODULE__{
        name: table_params["name"], 
        max_players: table_params["max_players"], 
        id: UUID.uuid4()
      })
    end
  end

  def all do
    Memento.transaction! fn ->
      Query.all(__MODULE__)
    end
  end

  def get(id) do
    Memento.transaction! fn ->
      Query.read(__MODULE__, id)
    end
  end
end
