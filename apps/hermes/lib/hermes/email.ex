defmodule Hermes.Email do
  import Swoosh.Email

  @from "vitor.roquep@gmail.com"

  def invite_email(email, table_name, link) do
    #TODO: Pass this to a module called Hermes.Office
    #where Hermes.Office always give the folder correctly to hermes mails
    IO.inspect(Path.expand("./priv/static/hermes/invite.html.eex"))
    mail = 
      new()
      |> to(email)
      |> from({"aedhron team", @from}) #change that when create the aedhron domain
      |> subject("Invitation to adventure #{table_name}")
      |> html_body(EEx.eval_file(Path.expand("./priv/static/hermes/invite.html.eex"), [
        email: email, 
        table_name: table_name,
        link: link
      ]))

    Task.start(fn -> 
      mail
      |> Hermes.Mailer.deliver
    end)
  end
end
