defmodule LiveViewResponsive.QueryBuilder do
  @moduledoc false

  import LiveViewResponsive.Constants.MediaTypesAndFeatures

  def build(opts) do
    query =
      Enum.find_value(opts, fn
        {"query", value} -> value
        _ -> false
      end)

    if is_nil(query) do
      Enum.map_join(opts, " and ", fn {key, value} ->
        validate_and_format_media_type_or_feature(key, value)
      end)
    else
      query
    end
  end

  @spec validate_and_format_media_type_or_feature(String.t(), String.t() | boolean() | number()) ::
          String.t()
  defp validate_and_format_media_type_or_feature(key, value) do
    case Map.get(media_types_and_features(), key) do
      nil ->
        raise_error_for_unknown_media_type_or_feature(key, value)

      :boolean ->
        validate_boolean_media_type_or_feature(key, value)

      :number ->
        validate_number_media_type_or_feature(key, value)

      :string_or_number ->
        validate_and_format_string_or_number_media_type_or_feature(key, value)

      available_values when is_list(available_values) ->
        validate_enum_media_type_or_feature(key, value, available_values)
    end
    |> then(&format_key_with_value(key, &1))
  end

  defp raise_error_for_unknown_media_type_or_feature(key, _value) do
    suggestion =
      media_types_and_features()
      |> Map.keys()
      |> Enum.max_by(&String.jaro_distance(key, &1))

    raise ArgumentError,
          """
          The media type or feature \"#{key}\" could not be found.
          Did you mean \"#{suggestion}\"?
          If your desired type or feature is not supported, you can use `query` to pass a custom media query.
          """
  end

  defp validate_boolean_media_type_or_feature(key, value) do
    unless is_boolean(value) do
      raise ArgumentError,
            "Expected a boolean for media type or feature \"#{key}\", got: #{inspect(value)}"
    end

    value
  end

  defp validate_number_media_type_or_feature(key, value) do
    unless is_number(value) do
      raise ArgumentError,
            "Expected a number for media type or feature \"#{key}\", got: #{inspect(value)}"
    end

    value
  end

  defp validate_and_format_string_or_number_media_type_or_feature(_key, value)
       when is_number(value) do
    "#{value}px"
  end

  defp validate_and_format_string_or_number_media_type_or_feature(key, value)
       when not is_binary(value) do
    raise ArgumentError,
          "Expected a string or number for media type or feature \"#{key}\", got: #{inspect(value)}"
  end

  defp validate_and_format_string_or_number_media_type_or_feature(_key, value) do
    value
  end

  defp validate_enum_media_type_or_feature(key, value, available_values) do
    unless Enum.member?(available_values, value) do
      raise ArgumentError,
            "Expected one of #{inspect(available_values)} for media type or feature \"#{key}\", got: #{inspect(value)}"
    end

    value
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
