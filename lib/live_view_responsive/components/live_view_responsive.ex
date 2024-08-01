defmodule LiveViewResponsive.Components.LiveViewResponsive do
  @moduledoc false

  import Phoenix.Component

  def live_view_responsive(assigns) do
    id = "liveview-responsive-#{:erlang.unique_integer([:positive])}"
    assigns = Map.put(assigns, :id, id)

    ~H"""
    <div phx-target={@myself} phx-hook="LiveViewResponsiveHook" id={@id}>
      <%= if Map.has_key?(assigns, :inner_block), do: render_slot(@inner_block), else: nil %>
    </div>
    """
  end
end
