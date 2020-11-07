defmodule Guard.Key do
  use Joken.Config
  use Timex

  def generate_authenticate_key(email) do
    {:ok, key, _info} = Guard.Key.generate_and_sign(%{ "owner" => email, "exp" => exp_one_day() })
    {:ok, key}
  end

  defp exp_one_day do
      Timex.now
      |> Timex.shift(days: 1)
      |> Timex.to_unix()
  end
end
