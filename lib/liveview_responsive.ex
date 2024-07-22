defmodule LiveviewResponsive do
  @moduledoc """
  Documentation for `LiveviewResponsive`.
  """

  defdelegate assign_media_query(socket, name, opts, default_value \\ false),
    to: LiveviewResponsive.Core

  defdelegate liveview_responsive_synced?(assigns), to: LiveviewResponsive.Core

  defdelegate liveview_responsive_hook(assigns), to: LiveviewResponsive.HookComponent

  defdelegate media_query(assigns), to: LiveviewResponsive.MediaQueryComponent

  defmacro __using__(_opts) do
    quote do
      import LiveviewResponsive

      @doc """
      Event handler for client-side media queries change.
      Runs `update` inside the component's module, so derived assigns can be calculated.
      """
      def handle_event("liveview-responsive-change", params, socket) do
        LiveviewResponsive.Core.liveview_responsive_change_event_handler(socket, params)
      end

      @doc """
      This function is called once from inside the `after_render` hook to push information about media queries to the client.
      For some reason it is not possible to `push_event` inside the hook, so this function is used instead.
      I used `handle_async`, because calls and casts are delegated to LiveView, not LiveComponent.
      """
      def handle_async(:liveview_responsive_start_sync, _params, socket) do
        LiveviewResponsive.Core.liveview_responsive_start_sync_async_handler(socket)
      end
    end
  end
end
