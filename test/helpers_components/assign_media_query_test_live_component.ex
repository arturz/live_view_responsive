defmodule LiveViewResponsive.AssignMediaQueryTestLiveComponent do
  use Phoenix.LiveComponent

  use LiveViewResponsive

  def mount(socket) do
    socket =
      socket
      |> assign_media_query(:is_portrait, orientation: "portrait")
      |> assign_media_query(:sm, max_width: "640px", initial: true)
      |> assign_media_query(:md, min_width: "641px", max_width: "1024px")
      |> assign_media_query(:lg, min_width: "1025px")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.live_view_responsive myself={@myself} />
      <p>
        #<%= @index %> <%= if assigns.is_portrait, do: "portrait", else: "landscape" %>
      </p>
      <span :if={@sm}>#<%= @index %> small screen</span>
      <span :if={@md}>#<%= @index %> medium screen</span>
      <span :if={@lg}>#<%= @index %> large screen</span>
    </div>
    """
  end
end
