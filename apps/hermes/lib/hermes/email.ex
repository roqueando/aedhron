defmodule Hermes.Email do
  import Swoosh.Email

  @from "vitor.roquep@gmail.com"

  def invite_email(email, table_name, table_id, key) do

    mail = 
      new()
      |> to(email)
      |> from({"aedhron team", @from}) #change that when create the aedhron domain
      |> subject("Invitation to adventure #{table_name}")
      |> html_body(EEx.eval_file(Hermes.get_mail("invite.html"), [
        email: email, 
        table_name: table_name,
        link: "http://localhost:4000/t/#{table_id}/i/#{key}"
      ]))

    Task.start(fn -> 
      mail
      |> Hermes.Mailer.deliver
    end)
  end

  def create_adventure(table_params, key) do
    mail = 
      new()
      |> to(table_params["email"])
      |> from({"aedhron team", @from}) #change that when create the aedhron domain
      |> subject("Adventure #{table_params["name"]} was created!")

    Task.start(fn -> 
      table = Warehouse.Table.create(%{
        "name" => table_params["name"],
        "max_players" => table_params["max_players"],
        "owner" => key
      })
      mail
      |> html_body(EEx.eval_file(Hermes.get_mail("adventure_created.html"), [
        table_name: table_params["name"],
        link: "http://localhost:4000/t/#{table.id}/k/#{key}"
      ]))
      |> Hermes.Mailer.deliver
    end)
  end
end
