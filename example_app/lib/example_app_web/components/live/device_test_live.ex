defmodule ExampleAppWeb.Components.Live.DeviceTestLive do
  @moduledoc """
  Live component for testing device/media query responsiveness. Uses Tailwind for styling.
  """

  use ExampleAppWeb, :live_component
  use ExampleApp.LiveViewResponsive

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign_sm_media_query()
      |> assign_md_media_query()
      |> assign_lg_media_query()
      |> assign_portrait_media_query()
      |> assign_landscape_media_query()

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="p-8 bg-gray-50 min-h-screen">
      <.live_view_responsive myself={@myself} />

      <h1 class="text-3xl font-bold text-gray-800 mb-2">Device Test</h1>
      <h2 class="text-xl font-semibold text-gray-700 mb-4">Media Query Components</h2>
      <ul class="mb-8 space-y-2">
        <li><.sm_media_query><span data-testid="component-sm" class="px-2 py-1 bg-blue-100 rounded">sm</span></.sm_media_query></li>
        <li><.md_media_query><span data-testid="component-md" class="px-2 py-1 bg-green-100 rounded">md</span></.md_media_query></li>
        <li><.lg_media_query><span data-testid="component-lg" class="px-2 py-1 bg-yellow-100 rounded">lg</span></.lg_media_query></li>
        <li><.portrait_media_query><span data-testid="component-portrait" class="px-2 py-1 bg-purple-100 rounded">portrait</span></.portrait_media_query></li>
        <li><.landscape_media_query><span data-testid="component-landscape" class="px-2 py-1 bg-pink-100 rounded">landscape</span></.landscape_media_query></li>
      </ul>
      <h2 class="text-xl font-semibold text-gray-700 mb-4">Media Query Assigns</h2>
      <ul class="space-y-2">
        <li :if={@sm}><span data-testid="assign-sm" class="px-2 py-1 bg-blue-200 rounded">sm</span></li>
        <li :if={@md}><span data-testid="assign-md" class="px-2 py-1 bg-green-200 rounded">md</span></li>
        <li :if={@lg}><span data-testid="assign-lg" class="px-2 py-1 bg-yellow-200 rounded">lg</span></li>
        <li :if={@portrait}><span data-testid="assign-portrait" class="px-2 py-1 bg-purple-200 rounded">portrait</span></li>
        <li :if={@landscape}><span data-testid="assign-landscape" class="px-2 py-1 bg-pink-200 rounded">landscape</span></li>
      </ul>
    </div>
    """
  end
end
