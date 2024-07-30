# liveview_responsive

## Information

Media queries in Phoenix LiveView for responsive design, heavily inspired by [react-responsive](https://github.com/yocontra/react-responsive).

## Install

Add liveview_responsive to your list of dependencies in mix.exs:

```elixir
# mix.exs
def deps do
  [
    {:liveview_responsive, "~> 1.0"}
  ]
end
```

In `assets/js/app.js` add liveview_responsive hooks:

```js
// assets/js/app.js
import {
  LiveviewResponsiveHook,
  LiveviewResponsiveMediaQueryHook,
} from "liveview_responsive";

let liveSocket = new LiveSocket("/live", Socket, {
  hooks: {
    LiveviewResponsiveHook,
    LiveviewResponsiveMediaQueryHook,
  },
});
```

## Example usage

### With `<.media_query>` component

```elixir
defmodule ExampleAppWeb.Example do
  use ExampleAppWeb, :component

  import LiveviewResponsive

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

- ✅ Uses `display` CSS property to toggle visibility. Everything stays in the browser. ⚡
- ✅ No need to write custom CSS or learn Tailwind.

### With media query assigns

```elixir
defmodule ExampleAppWeb.ExampleComponent do
  use ExampleAppWeb, :live_component

  use LiveviewResponsive

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
      <.liveview_responsive />

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

- ✅ Gives greater control what is rendered.
- ✅ Assigned media queries are just boolean values updated automatically.

Works only in [live components](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html). Both `use LiveviewResponsive` and `<.liveview_responsive />` are required to make media query assigns work.

## API

### Using properties

To make things more idiomatic to Phoenix Liveview, its preferred to use snake_case shorthants to construct media queries, but kebab-case syntax is also supported.

For a list of all possible shorthands see: TODO

If shorthand type is `string_or_number`, any number given will be expanded to px (`1234` becomes `1234px`).

Media queries can be constructed like this:

```elixir
socket
|> assign_media_query(:is_tablet, min_width: 600, max_width: 900)
```

or with media query component attributes:

```elixir
<.media_query min_width={600} max_width={900}>
  You are on tablet
</.media_query>
```

#### Supported media features

`orientation`, `scan`, `aspect_ratio`, `device_aspect_ratio`, `height`, `device_height`, `width`, `device_width`, `color`, `color_index`, `monochrome`, `resolution`.

Most of them support modifiers `min_` and `max_`.

#### Supported media types

`all`, `grid`, `aural`, `braille`, `handheld`, `print`, `projection`, `screen`, `tty`, `tv`, `embossed`.

To use media types pass them with `true` or `false` value.

```elixir
socket
|> assign_media_query(:is_screen, screen: true)      # screen
|> assign_media_query(:is_not_screen, screen: false) # not screen
```

#### Custom media query

It's possible to construct a custom media query:

```elixir
socket
|> assign_media_query(:is_custom, query: "(min-width: 600px) and (max-width: 900px)")
```

### Derived variables in live components

To calculate variable based on values of media queries assigns in live component you need to put them into `update/2` callback.

Given such media query assigns:

```elixir
def mount(socket) do
  socket
  |> assign_media_query(:is_mobile, min_width: 600)
  |> assign_media_query(:is_desktop, min_width: 1200)
end
```

❌ Do not create new variables based on these assigns in `render/1` callback. LiveView will not render changes when `small_screen` is updated, even if you put it into `assigns`.

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

### Initial value or hiding elements until media query is synced

Because `assign_media_query` calls need to receive information from the front-end, their values are all false on the first render. You can set initial values to render a specific layout or wait with rendering of depending elements until the client sent information about matching media queries.

💡 Component `<media_query>` is always up to date with the front-end, so it's safe to use it without any additional checks.

#### Initial value

To make media query initially matching, pass `true` as the last argument:

```elixir
|> assign_media_query(:is_mobile, min_width: 600, true)
|> assign_media_query(:is_desktop, min_width: 1200)
```

#### Hiding elements until synced

To hide elements until information about matching media queries is sent from the front-end and prevent flickering, use `:if` attribute with `liveview_responsive_synced?(assigns)` function call.

```elixir
def render(assigns) do
  ~H"""
  <div>
    <span :if={liveview_responsive_synced?(assigns)}>
      <%= if @small_screen, do: "Small screen", else: "Big screen" %>
    </span>
  </div>
  """
end
```

## Easy mode

You can create your application specific breakpoints or media queries and reuse them easily.

```elixir
defmodule ExampleApp.LiveviewResponsive do
  @moduledoc """
  Generates breakpoints for liveview-responsive design.

  For each breakpoint new component named `{breakpoint}_media_query` is generated, for example:

  <.mobile_media_query>
    You are on mobile
  </.mobile_media_query>

  And a function named `assign_{breakpoint}_media_query` is created, for example:

  socket
  |> assign_mobile_media_query(true)
  |> assign_tablet_media_query()
  """

  use LiveviewResponsive.Breakpoints, [
    mobile: [max_width: 700],
    tablet: [min_width: 701, max_width: 1200],
    desktop: [min_width: 1201],
  ]
end
```

Then you can use defined module instead of `LiveviewResponsive` in your components.

```elixir
defmodule ExampleAppWeb.Example do
  use ExampleAppWeb, :component

  import ExampleApp.LiveviewResponsive

  def example(assigns) do
    ~H"""
    <div>
      <.mobile_media_query>
        You are on mobile
      </.mobile_media_query>
      <.tablet_media_query>
        You are on tablet
      </.tablet_media_query>
      <.desktop_media_query>
        You are on desktop
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

  use ExampleApp.LiveviewResponsive

  def mount(socket) do
    socket
    |> assign_mobile_media_query()
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.liveview_responsive />
      <span :if={@mobile}>
        You are on mobile
      </span>
      ...
    </div>
    """
  end
end
```

# Roadmap

- [x] - Create breakpoints module
- [ ] - Fix `liveview_responsive_synced?` not updating on rerender (consider creating `liveview_responsive_synced` assign instead)
- [ ] - Add tests for `<.media_query>`
- [ ] - Add tests for `assign_media_query`
- [ ] - Add tests for breakpoints module
