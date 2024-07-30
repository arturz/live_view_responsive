defmodule LiveviewResponsive.QueryBuilder do
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

  import LiveviewResponsive.Utils.StringUtils

  def build(opts) do
    opts =
      Enum.map(opts, fn {key, value} ->
        key =
          key
          |> atom_to_string()
          |> replace_underscores_with_hyphens()

        {key, atom_to_string(value)}
      end)

    query =
      Enum.find_value(opts, fn
        {"query", value} -> value
        _ -> false
      end)

    unless is_nil(query) do
      query
    else
      opts
      |> Enum.map(fn {key, value} ->
        validate_and_format_media_type_or_feature(key, value)
      end)
      |> Enum.join(" and ")
    end
  end

  @spec validate_and_format_media_type_or_feature(String.t(), String.t() | boolean() | number()) ::
          String.t()
  defp validate_and_format_media_type_or_feature(key, value) do
    case Map.get(@media_types_and_features, key) do
      nil ->
        suggestion =
          @media_types_and_features
          |> Map.keys()
          |> Enum.max_by(&String.jaro_distance(key, &1))

        raise ArgumentError,
              "The media type or feature \"#{key}\" could not be found. Did you mean \"#{suggestion}\"?\nIf your desired type or feature is not supported, you can use `query` to pass a custom media query."

      :boolean ->
        unless is_boolean(value) do
          raise ArgumentError,
                "Expected a boolean for media type or feature \"#{key}\", got: #{inspect(value)}"
        end

        value

      :number ->
        unless is_number(value) do
          raise ArgumentError,
                "Expected a number for media type or feature \"#{key}\", got: #{inspect(value)}"
        end

        value

      :string_or_number ->
        if is_number(value) do
          "#{value}px"
        else
          if not is_binary(value) do
            raise ArgumentError,
                  "Expected a string or number for media type or feature \"#{key}\", got: #{inspect(value)}"
          end

          value
        end

      available_values when is_list(available_values) ->
        unless Enum.member?(available_values, value) do
          raise ArgumentError,
                "Expected one of #{inspect(available_values)} for media type or feature \"#{key}\", got: #{inspect(value)}"
        end

        value
    end
    |> then(&format_key_with_value(key, &1))
  end

  @spec format_key_with_value(String.t(), String.t() | boolean() | number()) :: String.t()
  defp format_key_with_value(key, true) do
    key
  end

  defp format_key_with_value(key, false) do
    "not #{key}"
  end

  defp format_key_with_value(key, value) do
    "(#{key}: #{value})"
  end
end
