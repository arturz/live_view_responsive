defmodule LiveViewResponsive do
  @moduledoc """
  Media queries for responsive design in Phoenix LiveView.

  ## Example

  ### With `<.media_query>` component

  ```elixir
  defmodule ExampleAppWeb.Example do
    use Phoenix.Component

    import LiveViewResponsive

    def example(assigns) do
      ~H\"\"\"
      <.media_query max_width={1224}>
        <p>You are on a tablet or mobile</p>
      </.media_query>
      <.media_query min_width={1225}>
        <p>You are on a desktop or laptop</p>
        <.media_query min_width={1500}>
          <p>You also have a huge screen</p>
        </.media_query>
      </.media_query>
      \"\"\"
    end
  end
  ```

  ### With media query assigns

  ```elixir
  defmodule ExampleAppWeb.ExampleComponent do
    use ExampleAppWeb, :live_component

    use LiveViewResponsive

    def mount(socket) do
      socket =
        socket
        |> assign_media_query(:tablet_or_mobile, max_width: "1224px")
        |> assign_media_query(:desktop_or_laptop, min_width: "1225px")
        |> assign_media_query(:portrait, orientation: "portrait")

      {:ok, socket}
    end

    @impl true
    def render(assigns) do
      ~H\"\"\"
      <div>
        <.live_view_responsive myself={@myself} />

        <div :if={@live_view_responsive_synced}>
          <h1>Device test</h1>
          <p :if={@desktop_or_laptop}>
            You are on a desktop or laptop
          </p>
          <p :if={@tablet_or_mobile}>
            You are on a tablet or mobile phone
          </p>
          <p>
            You are in
            <%= if assigns.portrait, do: "portrait", else: "landscape" %>
            orientation
          </p>
        </div>
      </div>
      \"\"\"
    end
  end
  ```
  """

  defdelegate assign_media_query(socket, name, opts),
    to: LiveViewResponsive.Core

  defdelegate live_view_responsive(assigns), to: LiveViewResponsive.Components.LiveViewResponsive

  defdelegate media_query(assigns), to: LiveViewResponsive.Components.MediaQuery

  defmacro __using__(_opts) do
    quote do
      import LiveViewResponsive

      @doc """
      Event handler for client-side media queries change.
      Runs `update` inside the component's module, so derived assigns can be calculated.
      """
      def handle_event("live-view-responsive-change", params, socket) do
        LiveViewResponsive.Core.live_view_responsive_change_event_handler(socket, params)
      end

      @doc """
      This function is called once from inside the `after_render` hook to push information about media queries to the client.
      For some reason it is not possible to `push_event` inside the hook, so this function is used instead.
      I used `handle_async`, because calls and casts are delegated to LiveView, not LiveComponent.
      """
      def handle_async(:live_view_responsive_push_queries_to_client, _params, socket) do
        LiveViewResponsive.Core.live_view_responsive_push_queries_to_client_handler(socket)
      end
    end
  end
end
