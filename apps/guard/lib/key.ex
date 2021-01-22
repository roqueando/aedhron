defmodule Guard.Key do
  use Joken.Config
  use Timex

  alias Warehouse.Table
  alias Warehouse.Invite

  def generate_authenticate_key(email) do
    {:ok, key, _info} = Guard.Key.generate_and_sign(%{ "owner" => email, "exp" => exp_one_day() })
    {:ok, key}
  end

  def validate_auth_key(key, table_id) do
    case Guard.Key.verify_and_validate(key) do
      {:ok, %{"owner" => owner} } ->
        is_auth_valid(owner, key, table_id)
      { :error, _reason } ->
        false
    end
  end

  def validate_invite_key(key, table_id) do
    invite = Invite.get_by_table(table_id, key)

    case Guard.Key.verify_and_validate(invite.key) do
      {:ok, %{ "owner" => invite_owner } } ->
        is_invite_valid(invite_owner, key, table_id, invite)
      { :error, _reason } ->
        false
    end
  end

  defp is_auth_valid(owner, key, table_id) do
    table = Table.get_by_owner_and_id(key, table_id)
            |> List.first

    if is_nil(table) do
      false
    else
      {:ok, %{"owner" => table_owner}} = Guard.Key.verify(table.owner)

      cond do
        owner === table_owner ->
          true
        owner !== table_owner ->
          false
      end
    end
  end

  defp is_invite_valid(invite_owner, key, _table_id, invite) do
    unless is_nil(invite) do
      case Guard.Key.verify_and_validate(key) do
        {:ok, %{"owner" => key_owner}} ->
          key_owner === invite_owner
        { :error, _param } ->
          false
      end
    end
  end

  defp exp_one_day do
    Timex.now
    |> Timex.shift(days: 1)
    |> Timex.to_unix()
  end
end
