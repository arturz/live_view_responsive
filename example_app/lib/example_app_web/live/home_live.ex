defmodule ExampleAppWeb.HomeLive do
  use ExampleAppWeb, :live_view

  import ExampleAppWeb.CoreComponents

  alias ExampleAppWeb.Components.Live.TreeDiagramLive

  def render(assigns) do
    ~H"""
    <div class="flex items-center justify-between mb-4">
      <.live_component module={TreeDiagramLive} id="tree-diagram" />
    </div>
    """
  end
end
