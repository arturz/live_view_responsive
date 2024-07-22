defmodule LiveviewResponsive.QueryBuilder do
  @moduledoc false

  def build(opts) do
    cond do
      opts[:query] -> opts[:query]
      true -> raise "Query is required"
    end
  end
end
