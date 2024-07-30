defmodule LiveviewResponsive.Breakpoints do
  @moduledoc """
  Generates breakpoints for liveview-responsive design.

  Usage:

  ```elixir
  defmodule ExampleApp.LiveviewResponsive do
    use LiveviewResponsive.Breakpoints, [
      mobile: [max_width: 700],
      tablet: [min_width: 701, max_width: 1200],
      desktop: [min_width: 1201],
    ]
  end
  ```

  Then you can `import` or `use` the module `ExampleApp.LiveviewResponsive` in your components.

  For each breakpoint a new component named `{breakpoint}_media_query` is generated, for example:

  ```elixir
  <.mobile_media_query>
    You are on mobile
  </.mobile_media_query>
  ```

  And a function named `assign_{breakpoint}_media_query` is created, for example:

  ```elixir
  socket
  |> assign_mobile_media_query(true)
  |> assign_tablet_media_query()
  ```
  """

  alias LiveviewResponsive.QueryBuilder

  defmacro __using__(breakpoints \\ []) do
    compile_breakpoints(breakpoints, __CALLER__.module)
  end

  def compile_breakpoints(breakpoints, breakpoints_module) do
    generated_functions_ast =
      Enum.map(breakpoints, fn {breakpoint, opts} ->
        query = QueryBuilder.build(opts)

        media_query_component_name = "#{breakpoint}_media_query" |> String.to_atom()
        assign_media_query_function_name = "assign_#{breakpoint}_media_query" |> String.to_atom()

        atom_breakpoint =
          if is_binary(breakpoint), do: String.to_atom(breakpoint), else: breakpoint

        quote do
          def unquote(media_query_component_name)(assigns) do
            assigns = Map.put(assigns, :query, unquote(query))
            var!(assigns) = assigns

            ~H"""
            <.media_query query={@query}>
              <%= if Map.has_key?(assigns, :inner_block), do: render_slot(@inner_block), else: nil %>
            </.media_query>
            """
          end

          def unquote(assign_media_query_function_name)(socket, default_value \\ false) do
            assign_media_query(
              socket,
              unquote(atom_breakpoint),
              [query: unquote(query)],
              default_value
            )
          end
        end
      end)

    quote do
      import Phoenix.Component
      import LiveviewResponsive

      unquote(generated_functions_ast)

      breakpoints_module = unquote(breakpoints_module)

      defmacro __using__(_opts) do
        breakpoints_module = unquote(breakpoints_module)

        quote do
          use LiveviewResponsive
          import unquote(breakpoints_module)
        end
      end
    end
  end
end
