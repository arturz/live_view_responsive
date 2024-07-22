# LiveviewResponsive

## Information

Media queries in Phoenix LiveView for responsive design.

## Install

```console

```

## Example usage

### With live component

```elixir
defmodule ExampleAppWeb.Example do
  use ExampleAppWeb, :live_component

  use LiveviewResponsive

  def mount(socket) do
    socket =
      socket
      |> assign_media_query(:is_desktop_or_laptop, query: "(min-width: 1224px)")
      |> assign_media_query(:is_tablet_or_mobile, query: "(max-width: 1224px)")
      |> assign_media_query(:is_portrait, query: "(orientation: portrait)")

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.liveview_responsive_hook />
      <h1>Device test</h1>
      <p :if={@is_desktop_or_laptop}>
        You are a desktop or laptop
      </p>
      <p :if={@is_tablet_or_mobile}>
        You are a tablet or mobile phone
      </p>
      <p>
        You are in
        <%= if assigns.is_portrait, do: "portrait", else: "landscape" %>
        orientation
      </p>
    </div>
    """
  end
```

### With `<.media_query>` component

```elixir
~H"""
<.media_query query="(max-width: 1224px)">
  <p>You are a tablet or mobile</p>
</.media_query>
<.media_query query="(min-width: 1224px)">
  <p>You are a desktop or laptop</p>
  <.media_query query="(min-width: 1424px)">
    <p>You also have a huge screen</p>
  </.media_query>
</.media_query>
"""
```

With media query component all changes are made on the client-side, so it works natively fast.
