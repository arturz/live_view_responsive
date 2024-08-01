defmodule LiveViewResponsive.BreakpointsTestLiveView do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={LiveViewResponsive.BreakpointsTestLiveComponent} id="test-live-component1" index={1} />
      <.live_component module={LiveViewResponsive.BreakpointsTestLiveComponent} id="test-live-component2" index={2} />
    </div>
    """
  end
end
