defmodule ExampleAppWeb.Components.Live.DeviceTestLive do
  @moduledoc false

  use ExampleAppWeb, :live_component
  use ExampleApp.LiveViewResponsive

  @impl true
  def mount(socket) do
    socket = socket
      |> assign_sm_media_query()
      |> assign_md_media_query()
      |> assign_lg_media_query()
      |> assign_portrait_media_query()

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.live_view_responsive myself={@myself} />

      <h1>Device test</h1>
      <h2>Media query components</h2>
      <ul>
        <li><.sm_media_query>sm</.sm_media_query></li>
        <li><.md_media_query>md</.md_media_query></li>
        <li><.lg_media_query>lg</.lg_media_query></li>
        <li><.portrait_media_query>portrait</.portrait_media_query></li>
      </ul>
      <h2>Media query assigns</h2>
      <ul>
        <li :if={@sm}>sm</li>
        <li :if={@md}>md</li>
        <li :if={@lg}>lg</li>
        <li :if={@portrait}>portrait</li>
      </ul>
    </div>
    """
  end
end
