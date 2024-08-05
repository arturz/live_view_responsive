# live_view_responsive

Media queries for responsive design in Phoenix LiveView, a server-rendered Elixir framework. Heavily inspired by [react-responsive](https://github.com/yocontra/react-responsive).

<div>
  <a href="https://github.com/arturz/live_view_responsive/actions/workflows/ci.yml">
    <img alt="CI Status" src="https://github.com/arturz/live_view_responsive/actions/workflows/ci.yml/badge.svg">
  </a>
  <a href="https://hex.pm/packages/live_view_responsive">
    <img alt="Hex Version" src="https://img.shields.io/hexpm/v/live_view_responsive.svg">
  </a>
  <a href="https://hexdocs.pm/live_view_responsive">
    <img alt="Hex Docs" src="https://img.shields.io/badge/hex.pm-docs-green.svg?style=flat">
  </a>
</div>

## Table of Contents

<ul style="margin-top: 2rem; margin-bottom: 2rem;">
  <li>
    <a href="#information">Information</a>
  </li>
  <li>
    <a href="#installation">Installation</a>
  </li>
  <li>
    <a href="#example-usage">Example Usage</a>
    <ul>
      <li><a href="#using-media_query-component">Using `<.media_query>` Component</a></li>
      <li><a href="#using-media-query-assigns">Using Media Query Assigns</a></li>
    </ul>
  </li>
  <li>
    <a href="#api">API</a>
    <ul>
      <li><a href="#using-properties">Using Properties</a></li>
      <li><a href="#supported-media-features">Supported Media Features</a></li>
      <li><a href="#supported-media-types">Supported Media Types</a></li>
      <li><a href="#custom-media-query">Custom Media Query</a></li>
      <li><a href="#initial-value-or-hiding-elements-until-media-query-is-synced">Initial Value or Hiding Elements Until Media Query is Synced
</a></li>
    </ul>
  </li>
  <li><a href="#easy-mode">Easy Mode</a></li>
  <li><a href="#faq">FAQ</a></li>
  <li><a href="#contributing">Contributing</a></li>
</ul>

## Information

`live_view_responsive` provides an easy way to manage media queries in Phoenix LiveView applications. It allows you to create responsive designs without the need to write custom media queries or learn Tailwind CSS.

## Installation

Before you begin, ensure you have the following prerequisites:

- Elixir 1.13+
- Phoenix LiveView 0.20+

Add live_view_responsive to your list of dependencies in mix.exs:

```elixir
# mix.exs
def deps do
  [
    {:live_view_responsive, "~> 0.1.1"}
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

## Example Usage

### Using `<.media_query>` component

```elixir
defmodule ExampleAppWeb.Example do
  use Phoenix.Component

  import LiveViewResponsive

  def example(assigns) do
    ~H"""
    <.media_query max_width={1224}>
      <p>You are on a tablet or mobile</p>
    </.media_query>
    <.media_query min_width={1225}>
      <p>You are on a desktop or laptop</p>
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

### Using media query assigns

```elixir
defmodule ExampleAppWeb.ExampleComponent do
  use ExampleAppWeb, :live_component

  use LiveViewResponsive

  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign_media_query(:tablet_or_mobile, max_width: 1224)
      |> assign_media_query(:desktop_or_laptop, min_width: 1225)
      |> assign_media_query(:portrait, orientation: "portrait")

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.live_view_responsive myself={@myself} />

      <h1>Device test</h1>
      <p :if={@tablet_or_mobile}>
        You are on a tablet or mobile phone
      </p>
      <p :if={@desktop_or_laptop}>
        You are on a desktop or laptop
      </p>
      <p>
        You are in
        <%= if assigns.portrait, do: "portrait", else: "landscape" %>
        orientation
      </p>
    </div>
    """
  end
end
```

- ✅ Gives greater control over what is rendered.
- ✅ Assigned media queries are just boolean values updated automatically.

Note: Works only in [live components](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html). Both `use LiveViewResponsive` and `<.live_view_responsive myself={@myself} />` are required to make media query assigns work.

## API

### Using properties

To make things more idiomatic to Phoenix LiveView, its preferred to use snake_case shorthands to construct media queries, but the kebab-case syntax is also supported.

For a list of all possible shorthands see [media_types_and_features.ex](https://github.com/arturz/live_view_responsive/tree/main/lib/live_view_responsive/constants/media_types_and_features.ex).

If shorthand accepts a string or number, any number given will be expanded to px (`1234` becomes `1234px`).

Media query assigns can be constructed like this:

```elixir
socket
|> assign_media_query(:tablet, min_width: 600, max_width: 900)
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
|> assign_media_query(:screen, screen: true)      # screen
|> assign_media_query(:not_screen, screen: false) # not screen
```

#### Custom media query

Sometimes you need to create a complex query or use a bleeding edge feature. In such cases, you can pass a custom query string.

```elixir
socket
|> assign_media_query(:tablet, query: "(min-width: 600px) and (max-width: 900px)")
```

### Initial value or hiding elements until media query is synced

Because `assign_media_query` calls need to receive information from the front-end, their values are all set to false on the first render.

💡 The `<.media_query>` component is always up to date, so it's safe to use without additional checks.

#### Hiding elements until synced

To hide elements until information about matching media queries is received from the front-end for the first time and prevent flickering, check the `@live_view_responsive_synced` assign.

```elixir
def render(assigns) do
  ~H"""
  <div>
    <.live_view_responsive myself={@myself} />

    <span :if={@live_view_responsive_synced}>
      <%= if @small_screen, do: "Small screen", else: "Big screen" %>
    </span>
  </div>
  """
end
```

#### Initial value

Alternatively, to make the media query match on the first render, add the `initial: true` keyword:

```elixir
|> assign_media_query(:mobile, min_width: 600, initial: true)
|> assign_media_query(:desktop, min_width: 1200)
```

## Easy mode

You can create your application-specific breakpoints and reuse them easily.

```elixir
defmodule ExampleApp.LiveViewResponsive do
  @moduledoc """
  Generates breakpoints for live_view_responsive design.

  For each breakpoint new component named `{breakpoint}_media_query` is generated, for example:

  <.mobile_media_query>
    You are on a mobile
  </.mobile_media_query>

  And a function named `assign_{breakpoint}_media_query` is created, for example:

  socket
  |> assign_mobile_media_query(initial: true)
  |> assign_tablet_media_query()
  """

  use LiveViewResponsive.Breakpoints, [
    mobile: [max_width: 700],
    tablet: [min_width: 701, max_width: 1200],
    desktop: [min_width: 1201],
  ]
end
```

Then you can use the defined module instead of `LiveViewResponsive` in your components.

```elixir
defmodule ExampleAppWeb.Example do
  use Phoenix.Component

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

  @impl true
  def mount(socket) do
    socket
    |> assign_mobile_media_query()
  end

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

## FAQ

<details>
<summary>Changes of the new variable based on media query assigns do not cause rerender of live component</summary>

It happens when you calculate new variables based on the media query assigns in the `render/1` callback. You have to assign them in the `update/2` callback instead.

Given such media query assigns:

```elixir
@impl true
def mount(socket) do
  socket
  |> assign_media_query(:mobile, min_width: 600)
  |> assign_media_query(:desktop, min_width: 1200)
end
```

❌ Do not create new variables based on these assigns in the `render/1` callback. LiveView will not render changes when `small_screen` is updated, even if you put it into assigns.

```elixir
def render(assigns) do
  # this will not work
  small_screen = assigns.mobile and not assigns.desktop

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
  small_screen = assigns.mobile and not assigns.desktop

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

## Contributing

Contributions of any kind are welcome! If you have a feature request, found a bug, or want to improve the documentation, feel free to open an issue or a pull request. And don't forget to star the repository if you like the project. 🌟
