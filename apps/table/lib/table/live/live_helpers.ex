defmodule Table.LiveHelpers do
  import Phoenix.LiveView.Helpers

  def live_modal(socket, component, opts) do
    path = Keyword.fetch! opts, :return_to 
    modal_opts = [
      id: :modal, 
      return_to: path, 
      component: component, 
      opts: opts
    ]
    live_component(socket, Table.Components.Modal, modal_opts)
  end
end
