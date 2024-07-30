defmodule LiveviewResponsive.Components.MediaQuery do
  @moduledoc false

  use Phoenix.Component

  alias LiveviewResponsive.QueryBuilder

  # custom query
  attr(:query, :string)

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
  attr(:aspect_ratio, :any)
  attr(:min_aspect_ratio, :any)
  attr(:max_aspect_ratio, :any)

  # device aspect ratio
  attr(:device_aspect_ratio, :any)
  attr(:min_device_aspect_ratio, :any)
  attr(:max_device_aspect_ratio, :any)

  # height
  attr(:height, :any)
  attr(:min_height, :any)
  attr(:max_height, :any)

  # device height
  attr(:device_height, :any)
  attr(:min_device_height, :any)
  attr(:max_device_height, :any)

  # width
  attr(:width, :any)
  attr(:min_width, :any)
  attr(:max_width, :any)

  # device width
  attr(:device_width, :any)
  attr(:min_device_width, :any)
  attr(:max_device_width, :any)

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
  attr(:resolution, :any)
  attr(:min_resolution, :any)
  attr(:max_resolution, :any)

  attr(:rest, :any)

  def media_query(assigns) do
    query = assigns |> assigns_to_attributes() |> QueryBuilder.build()

    id = "liveview-responsive-#{:erlang.unique_integer([:positive])}"

    ~H"""
    <div
      data-query={query}
      id={id}
      phx-hook="LiveviewResponsiveMediaQueryHook"
      style="display: none;"
    >
      <%= if Map.has_key?(assigns, :inner_block), do: render_slot(@inner_block), else: nil %>
    </div>
    """
  end
end
