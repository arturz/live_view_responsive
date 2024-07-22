defmodule LiveviewResponsive.MediaQueryComponent do
  @moduledoc false

  import Phoenix.Component

  alias LiveviewResponsive.QueryBuilder

  def media_query(assigns) do
    query = QueryBuilder.build(assigns)
    id = "liveview-responsive-#{:erlang.unique_integer([:positive])}"

    ~H"""
    <div
      data-query={query}
      id={id}
      phx-hook="LiveviewResponsiveMediaQueryHook"
      style="display: none;"
    >
      <%= if Map.has_key?(assigns, :inner_block), do: render_slot(@inner_block), else: nil %>
    </div>
    """
  end
end
