defmodule LiveViewResponsive.OptsParser do
  @moduledoc false

  import LiveViewResponsive.Utils.StringUtils

  @type opts :: list({String.t(), String.t()})

  @spec parse(
          list({atom(), atom() | String.t()})
          | %{
              optional(atom() | String.t()) => atom() | String.t()
            }
        ) ::
          opts()
  def parse(opts) do
    Enum.map(opts, fn {key, value} ->
      key =
        key
        |> atom_to_string()
        |> replace_underscores_with_hyphens()

      {key, atom_to_string(value)}
    end)
  end

  @spec pop(opts(), String.t(), arg) :: {String.t() | arg, opts()} when arg: var
  def pop(opts, key, default_value \\ nil) do
    index = Enum.find_index(opts, &(&1 |> elem(0) == key))

    if is_nil(index) do
      {default_value, opts}
    else
      {{_key, value}, opts} = List.pop_at(opts, index)
      {value, opts}
    end
  end
end
