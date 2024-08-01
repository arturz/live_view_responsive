defmodule LiveViewResponsive.BreakpointsTestLiveComponent do
  @moduledoc false

  use Phoenix.LiveComponent
  use LiveViewResponsive.LiveViewResponsiveWithBreakpoints

  def mount(socket) do
    socket =
      socket
      |> assign_mobile_media_query()
      |> assign_tablet_media_query(initial: true)
      |> assign_desktop_media_query()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.live_view_responsive myself={@myself} />
      <.portrait_media_query>
        Portrait
      </.portrait_media_query>
      <span :if={@mobile}>#<%= @index %> mobile</span>
      <span :if={@tablet}>#<%= @index %> tablet</span>
      <span :if={@desktop}>#<%= @index %> desktop</span>
    </div>
    """
  end
end
