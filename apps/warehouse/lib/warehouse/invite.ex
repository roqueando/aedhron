defmodule Warehouse.Invite do
  use Memento.Table, attributes: [:id, :key, :max_uses, :reference]
  alias Memento.Query

  def create(invite_params) do
    Memento.transaction! fn ->
      Query.write(%__MODULE__{
        key: invite_params["key"], 
        max_uses: invite_params["max_uses"], 
        id: UUID.uuid4(),
        reference: invite_params["reference"]
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
