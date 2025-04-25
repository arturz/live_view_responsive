defmodule ExampleAppWeb.HomeLive do
  use ExampleAppWeb, :live_view

  alias ExampleAppWeb.Components.Live.DeviceTestLive
  alias ExampleAppWeb.Components.Live.TreeDiagramLive

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-4">
      <.live_component module={DeviceTestLive} id="device-test" />
      <hr />
      <.live_component module={TreeDiagramLive} id="tree-diagram" />
    </div>
    """
  end
end
