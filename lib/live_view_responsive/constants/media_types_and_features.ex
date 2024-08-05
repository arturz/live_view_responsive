defmodule LiveViewResponsive.Constants.MediaTypesAndFeatures do
  @moduledoc false

  @media_types_and_features %{
    # media types
    "all" => :boolean,
    "grid" => :boolean,
    "aural" => :boolean,
    "braille" => :boolean,
    "handheld" => :boolean,
    "print" => :boolean,
    "projection" => :boolean,
    "screen" => :boolean,
    "tty" => :boolean,
    "tv" => :boolean,
    "embossed" => :boolean,

    # media features
    "orientation" => ["portrait", "landscape"],
    "scan" => ["progressive", "interlace"],

    # aspect ratio
    "aspect-ratio" => :string_or_number,
    "min-aspect-ratio" => :string_or_number,
    "max-aspect-ratio" => :string_or_number,

    # device aspect ratio
    "device-aspect-ratio" => :string_or_number,
    "min-device-aspect-ratio" => :string_or_number,
    "max-device-aspect-ratio" => :string_or_number,

    # height
    "height" => :string_or_number,
    "min-height" => :string_or_number,
    "max-height" => :string_or_number,

    # device height
    "device-height" => :string_or_number,
    "min-device-height" => :string_or_number,
    "max-device-height" => :string_or_number,

    # width
    "width" => :string_or_number,
    "min-width" => :string_or_number,
    "max-width" => :string_or_number,

    # device width
    "device-width" => :string_or_number,
    "min-device-width" => :string_or_number,
    "max-device-width" => :string_or_number,

    # color
    "color" => :boolean,
    "min-color" => :number,
    "max-color" => :number,

    # color index
    "color-index" => :boolean,
    "min-color-index" => :number,
    "max-color-index" => :number,

    # monochrome
    "monochrome" => :boolean,
    "min-monochrome" => :number,
    "max-monochrome" => :number,

    # resolution
    "resolution" => :string_or_number,
    "min-resolution" => :string_or_number,
    "max-resolution" => :string_or_number
  }

  def media_types_and_features do
    @media_types_and_features
  end
end
