defmodule Table do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, views, channels and so on.

  This can be used in your application as:

      use Table, :controller
      use Table, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define any helper function in modules
  and import those modules here.
  """

  def controller do
    quote do
      use Phoenix.Controller, namespace: Table

      import Plug.Conn
      import Table.Gettext
      import Phoenix.LiveView.Controller
      alias Table.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/table/templates",
        namespace: Table

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_flash: 1, get_flash: 2, view_module: 1, view_template: 1]
      import Phoenix.LiveView.Helpers

      # Include shared imports and aliases for views
      unquote(view_helpers())
    end
  end

  def router do
    quote do
      use Phoenix.Router

      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Table.Gettext
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {Table.LayoutView, "live.html"}

      def handle_event("open_modal", _value, socket) do
        send_update Table.Components.Modal, id: "modal-create", state: :open, type: :create
        {:noreply, socket}
      end

      def handle_event("close_modal", _value, socket) do
        send_update Table.Components.Modal, id: "modal-create", state: :closed
        {:noreply, socket}
      end

      def handle_event("open_add_token_modal", _value, socket) do
        send_update Table.Components.Modal, id: "modal-create", state: :open, type: :add_token
        {:noreply, socket}
      end
      
      def component_id, do: Warehouse.generate_id
      unquote(view_helpers())
    end
  end

  def live_component do
    quote do
     use Phoenix.LiveComponent 
      unquote(view_helpers())
    end
  end

  defp view_helpers do
    quote do
      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      # Import basic rendering functionality (render, render_layout, etc)
      import Phoenix.View

      import Table.ErrorHelpers
      import Table.Gettext
      alias Table.Router.Helpers, as: Routes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def subscribe(table_id) do
    Phoenix.PubSub.subscribe(Table.PubSub, "tables:" <> table_id)
  end

  def broadcast(resource, event, table_id) do
    Phoenix.PubSub.broadcast(Table.PubSub, "tables:" <> table_id, {event, resource})
    resource
  end
end
