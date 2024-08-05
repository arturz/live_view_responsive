defmodule LiveViewResponsive.Components.MediaQuery do
  @moduledoc """
  Module containing `<.media_query>` component.
  """

  use Phoenix.Component

  alias LiveViewResponsive.OptsParser
  alias LiveViewResponsive.QueryBuilder

  @string_or_number_doc "String or number. When number is passed, suffix `px` is added."

  # custom query
  attr(:query, :string, doc: "Custom media query. When used, other attributes are ignored.")

  # media types
  attr(:all, :boolean)
  attr(:grid, :boolean)
  attr(:aural, :boolean)
  attr(:braille, :boolean)
  attr(:handheld, :boolean)
  attr(:print, :boolean)
  attr(:projection, :boolean)
  attr(:screen, :boolean)
  attr(:tty, :boolean)
  attr(:tv, :boolean)
  attr(:embossed, :boolean)

  # media features
  attr(:orientation, :any, values: [:portrait, :landscape, "portrait", "landscape"])
  attr(:scan, :any, values: [:progressive, :interlace, "progressive", "interlace"])

  # aspect ratio
  attr(:aspect_ratio, :any, doc: @string_or_number_doc)
  attr(:min_aspect_ratio, :any, doc: @string_or_number_doc)
  attr(:max_aspect_ratio, :any, doc: @string_or_number_doc)

  # device aspect ratio
  attr(:device_aspect_ratio, :any, doc: @string_or_number_doc)
  attr(:min_device_aspect_ratio, :any, doc: @string_or_number_doc)
  attr(:max_device_aspect_ratio, :any, doc: @string_or_number_doc)

  # height
  attr(:height, :any, doc: @string_or_number_doc)
  attr(:min_height, :any, doc: @string_or_number_doc)
  attr(:max_height, :any, doc: @string_or_number_doc)

  # device height
  attr(:device_height, :any, doc: @string_or_number_doc)
  attr(:min_device_height, :any, doc: @string_or_number_doc)
  attr(:max_device_height, :any, doc: @string_or_number_doc)

  # width
  attr(:width, :any, doc: @string_or_number_doc)
  attr(:min_width, :any, doc: @string_or_number_doc)
  attr(:max_width, :any, doc: @string_or_number_doc)

  # device width
  attr(:device_width, :any, doc: @string_or_number_doc)
  attr(:min_device_width, :any, doc: @string_or_number_doc)
  attr(:max_device_width, :any, doc: @string_or_number_doc)

  # color
  attr(:color, :boolean)
  attr(:min_color, :integer)
  attr(:max_color, :integer)

  # color index
  attr(:color_index, :boolean)
  attr(:min_color_index, :integer)
  attr(:max_color_index, :integer)

  # monochrome
  attr(:monochrome, :boolean)
  attr(:min_monochrome, :integer)
  attr(:max_monochrome, :integer)

  # resolution
  attr(:resolution, :any, doc: @string_or_number_doc)
  attr(:min_resolution, :any, doc: @string_or_number_doc)
  attr(:max_resolution, :any, doc: @string_or_number_doc)

  attr(:rest, :any, doc: @string_or_number_doc)

  @doc """
  A component which shows or hides children on the front-end side based on a media query.

  Uses the `LiveViewResponsiveMediaQueryHook` hook.

  ## Example

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
  """
  def media_query(assigns) do
    query = assigns |> assigns_to_attributes() |> OptsParser.parse() |> QueryBuilder.build()

    id = "live-view-responsive-media-query-#{:erlang.unique_integer([:positive])}"

    assigns = assign(assigns, query: query, id: id)

    ~H"""
    <div
      data-query={@query}
      id={@id}
      phx-hook="LiveViewResponsiveMediaQueryHook"
      style="display: none;"
    >
      <%= if Map.has_key?(assigns, :inner_block), do: render_slot(@inner_block), else: nil %>
    </div>
    """
  end
end
