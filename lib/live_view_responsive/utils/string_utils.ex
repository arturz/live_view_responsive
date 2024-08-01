defmodule LiveViewResponsive.Utils.StringUtils do
  @moduledoc false

  @spec atom_to_string(atom()) :: String.t()
  @spec atom_to_string(arg) :: arg when arg: var
  def atom_to_string(value) when is_atom(value) and not is_boolean(value) and not is_nil(value),
    do: Atom.to_string(value)

  def atom_to_string(value), do: value

  @spec replace_underscores_with_hyphens(String.t()) :: String.t()
  def replace_underscores_with_hyphens(string) do
    String.replace(string, "_", "-")
  end
end
