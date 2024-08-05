defmodule LiveViewResponsive.Components.LiveViewResponsive do
  @moduledoc """
  Module containing `<.live_view_responsive>` component.
  """

  use Phoenix.Component

  attr(:myself, :any, required: true, doc: "@myself assign from the parent component")

  @doc """
  Renders `LiveViewResponsiveHook` hook required for `LiveViewResponsive.Core.assign_media_query/3`.

  ## Example

  ```elixir
  def render(assigns) do
    ~H\"\"\"
    <div>
      <.live_view_responsive myself={@myself} />
      ...
    </div>
    \"\"\"
  end
  ```
  """
  def live_view_responsive(assigns) do
    unless Map.has_key?(assigns, :myself) do
      raise """
      Required `:myself` assign is missing. It should be set to `@myself` in the parent component.
      Example: `<.live_view_responsive myself={@myself} />`
      """
    end

    id = "live-view-responsive-#{assigns.myself.cid}"
    assigns = Map.put(assigns, :id, id)

    ~H"""
    <div phx-target={@myself} phx-hook="LiveViewResponsiveHook" id={@id}>
      <%= if Map.has_key?(assigns, :inner_block), do: render_slot(@inner_block), else: nil %>
    </div>
    """
  end
end
