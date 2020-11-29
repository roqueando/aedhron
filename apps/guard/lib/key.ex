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
    %{ "owner" => owner } = Guard.Key.verify_and_validate!(key);
    table = Table.get_by_owner_and_id(key, table_id)
            |> List.first
    if is_nil(table) do
      {:error, "You're not invited or is the god of this adventure!"}
      false
    else
      {:ok, %{"owner" => table_owner}} = Guard.Key.verify(table.owner)

      cond do
        owner === table_owner ->
          true
        owner !== table_owner ->
          {:error, "You're not invited or god of this adventure!"}
      end
    end
  end

  def validate_invite_key(key, table_id) do
    invite = Invite.get_by_table(table_id, key)
    %{ "owner" => invite_owner } = Guard.Key.verify_and_validate!(invite.key)

    if is_nil(invite) do
      {:error, "You're not invited or is the god of this adventure!"}
      false
    else
      %{ "owner" => key_owner } = Guard.Key.verify_and_validate!(key);
      cond do
        key_owner === invite_owner ->
          true
        key_owner !== invite_owner ->
          {:error, "You're not invited or god of this adventure!"}
      end
    end
  end


  defp exp_one_day do
      Timex.now
      |> Timex.shift(days: 1)
      |> Timex.to_unix()
  end
end
