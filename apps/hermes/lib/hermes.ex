defmodule Hermes do
  def get_mail(file), do: Path.expand("./priv/static/hermes/#{file}.eex")
end
