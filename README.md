# live_view_responsive

## Information

Media queries for responsive design in Phoenix LiveView, a server-rendered framework. It is heavily inspired by [react-responsive](https://github.com/yocontra/react-responsive).

## Install

Add live_view_responsive to your list of dependencies in mix.exs:

```elixir
# mix.exs
def deps do
  [
    {:live_view_responsive, "~> 1.0"}
  ]
end
```

In `assets/js/app.js` add live_view_responsive hooks:

```js
// assets/js/app.js
import {
  LiveViewResponsiveHook,
  LiveViewResponsiveMediaQueryHook,
} from "live_view_responsive";

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    LiveViewResponsiveHook,
    LiveViewResponsiveMediaQueryHook,
  },
});
```

## Example usage

### With `<.media_query>` component

```elixir
defmodule ExampleAppWeb.Example do
  use ExampleAppWeb, :component

  import LiveViewResponsive

  def example(assigns) do
    ~H"""
    <.media_query max_width={1224}>
      <p>You are a tablet or mobile</p>
    </.media_query>
    <.media_query min_width={1225}>
      <p>You are a desktop or laptop</p>
      <.media_query min_width={1500}>
        <p>You also have a huge screen</p>
      </.media_query>
    </.media_query>
    """
  end
end
```

- ✅ Toggles CSS display property on media query change with zero latency. ⚡
- ✅ No need to write custom media queries or learn Tailwind.

### With media query assigns

```elixir
defmodule ExampleAppWeb.ExampleComponent do
  use ExampleAppWeb, :live_component

  use LiveViewResponsive

  def mount(socket) do
    socket =
      socket
      |> assign_media_query(:is_tablet_or_mobile, max_width: "1224px")
      |> assign_media_query(:is_desktop_or_laptop, min_width: "1225px")
      |> assign_media_query(:is_portrait, orientation: "portrait")

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.live_view_responsive myself={@myself} />
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
end
```

- ✅ Gives greater control over what is rendered.
- ✅ Assigned media queries are just boolean values updated automatically.

Works only in [live components](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html). Both `use LiveViewResponsive` and `<.live_view_responsive myself={@myself} />` are required to make media query assigns work.

## API

### Using properties

To make things more idiomatic to Phoenix LiveView, its preferred to use snake_case shorthands to construct media queries, but the kebab-case syntax is also supported.

For a list of all possible shorthands see [query_builder.ex](https://github.com/arturz/live_view_responsive/blob/1a3649fd36ebd94bb15fa457e30691c890c9e047/lib/live_view_responsive/query_builder.ex#L4).

If shorthand accepts a string or number, any number given will be expanded to px (`1234` becomes `1234px`).

Media query assigns can be constructed like this:

```elixir
socket
|> assign_media_query(:is_tablet, min_width: 600, max_width: 900)
```

or with media query component attributes:

```elixir
<.media_query min_width={600} max_width={900}>
  You are on a tablet
</.media_query>
```

#### Supported media features

`orientation`, `scan`, `aspect_ratio`, `device_aspect_ratio`, `height`, `device_height`, `width`, `device_width`, `color`, `color_index`, `monochrome`, `resolution`.

Most support modifiers `min_` and `max_`.

#### Supported media types

`all`, `grid`, `aural`, `braille`, `handheld`, `print`, `projection`, `screen`, `tty`, `tv`, `embossed`.

To use media types pass them with `true` or `false` value.

```elixir
socket
|> assign_media_query(:is_screen, screen: true)      # screen
|> assign_media_query(:is_not_screen, screen: false) # not screen
```

#### Custom media query

Sometimes you need to create a complex query or a bleeding edge feature. In such cases, you can pass a custom query string.

```elixir
socket
|> assign_media_query(:is_custom, query: "(min-width: 600px) and (max-width: 900px)")
```

### Initial value or hiding elements until media query is synced

Because `assign_media_query` calls need to receive information from the JS, their values are all set to false on the first render.

💡 Component `<media_query>` is always up to date with the front-end, so it's safe to use without additional checks.

#### Hiding elements until synced

To hide elements until information about matching media queries is received and prevent flickering, check the `live_view_responsive_synced` assign.

```elixir
def render(assigns) do
  ~H"""
  <div>
    <span :if={@live_view_responsive_synced}>
      <%= if @small_screen, do: "Small screen", else: "Big screen" %>
    </span>
  </div>
  """
end
```

#### Initial value

To make the media query match on the first render, add the `initial: true` keyword:

```elixir
|> assign_media_query(:is_mobile, min_width: 600, initial: true)
|> assign_media_query(:is_desktop, min_width: 1200)
```

## Easy mode

You can create your application-specific breakpoints and reuse them easily.

```elixir
defmodule ExampleApp.LiveViewResponsive do
  @moduledoc """
  Generates breakpoints for liveview_responsive design.

  For each breakpoint new component named `{breakpoint}_media_query` is generated, for example:

  <.mobile_media_query>
    You are on a mobile
  </.mobile_media_query>

  And a function named `assign_{breakpoint}_media_query` is created, for example:

  socket
  |> assign_mobile_media_query(true)
  |> assign_tablet_media_query()
  """

  use LiveViewResponsive.Breakpoints, [
    mobile: [max_width: 700],
    tablet: [min_width: 701, max_width: 1200],
    desktop: [min_width: 1201],
  ]
end
```

Then you can use a defined module instead of `LiveViewResponsive` in your components.

```elixir
defmodule ExampleAppWeb.Example do
  use ExampleAppWeb, :component

  import ExampleApp.LiveViewResponsive

  def example(assigns) do
    ~H"""
    <div>
      <.mobile_media_query>
        You are on a mobile
      </.mobile_media_query>
      <.tablet_media_query>
        You are on a tablet
      </.tablet_media_query>
      <.desktop_media_query>
        You are on a desktop
      </.desktop_media_query>
    </div>
    """
  end
end
```

Same thing with live components:

```elixir
defmodule ExampleAppWeb.ExampleLiveComponent do
  use ExampleAppWeb, :live_component

  use ExampleApp.LiveViewResponsive

  def mount(socket) do
    socket
    |> assign_mobile_media_query()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.live_view_responsive myself={@myself} />
      <span :if={@mobile}>
        You are on a mobile
      </span>
      ...
    </div>
    """
  end
end
```

# FAQ

<details>
<summary>Changes of a new variable based on media query assigns do not cause rerender of live component</summary>

It happens when you calculate new variables based on the media query assigns in the `render/1` callback. You have to assign them in the `update/2` callback instead.

Given such media query assigns:

```elixir
def mount(socket) do
  socket
  |> assign_media_query(:is_mobile, min_width: 600)
  |> assign_media_query(:is_desktop, min_width: 1200)
end
```

❌ Do not create new variables based on these assigns in the `render/1` callback. LiveView will not render changes when `small_screen` is updated, even if you put it into assigns.

```elixir
def render(assigns) do
  # this will not work
  small_screen = assigns.is_mobile and not assigns.is_desktop

  ~H"""
  <div>
    <span :if={small_screen}>Small screen</span>
  </div>
  """
end
```

✅ Instead, calculate new variables in `update/2` callback:

```elixir
@impl true
def update(assigns, socket) do
  small_screen = assigns.is_mobile and not assigns.is_desktop

  socket = assign(socket, :small_screen, small_screen)

  {:ok, assign(socket, assigns)}
end

def render(assigns) do
  ~H"""
  <div>
    <span :if={@small_screen}>Small screen</span>
  </div>
  """
end
```

</details>

# Roadmap

- [x] - Create breakpoints module
- [x] - Fix `live_view_responsive_synced?` not updating on rerender (consider creating `live_view_responsive_synced` assign instead)
- [x] - Add tests for `<.media_query>`
- [x] - Add tests for `assign_media_query`
- [x] - Add tests for breakpoints module
- [x] - Change name to `live_view_responsive`
- [x] - Remove last default argument of assign_media_query and use `initial` key instead
