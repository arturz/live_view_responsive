defmodule LiveviewResponsive.Components.LiveviewResponsive do
  @moduledoc false

  import Phoenix.Component

  def liveview_responsive(assigns) do
    id = "liveview-responsive-#{:erlang.unique_integer([:positive])}"
    assigns = Map.put(assigns, :id, id)

    ~H"""
    <div phx-hook="LiveviewResponsiveHook" id={@id}>
      <%= if Map.has_key?(assigns, :inner_block), do: render_slot(@inner_block), else: nil %>
    </div>
    """
  end
end
