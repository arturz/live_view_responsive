defmodule LiveViewResponsive.Core do
  @moduledoc """
  Core LiveViewResponsive module.
  """

  # < 0.18.0 assign/2 and assign/3 were inside Phoenix.LiveView
  import Phoenix.LiveView
  import Phoenix.Component

  alias LiveViewResponsive.OptsParser
  alias LiveViewResponsive.QueryBuilder
  alias LiveViewResponsive.State

  alias Phoenix.LiveView.Socket

  @private_live_view_responsive_after_render_hook :private_live_view_responsive_after_render_hook
  @private_live_view_responsive_data :private_live_view_responsive_data
  @live_view_responsive_synced :live_view_responsive_synced

  @doc """
  Assigns a boolean value that is automatically updated based on whether the media query matches.

  Requires `LiveViewResponsive.Components.LiveViewResponsive.live_view_responsive/1` to be rendered in the template and `use LiveViewResponsive` definition in the live component module.

  When information about all matching media queries is received from the front-end for the first time, the assign `@live_view_responsive_synced` is set to true.

  ## Options

  - Media types and features from [media_types_and_features.ex](https://github.com/arturz/live_view_responsive/tree/main/lib/live_view_responsive/constants/media_types_and_features.ex).
  - `initial` - initial value of media query assign before information about matching is received. By default `false`.

  ## Example

  ```elixir
  @impl true
  def mount(socket) do
    socket =
      socket
      |> assign_media_query(:tablet_or_mobile, max_width: "1224px", initial: true)
      |> assign_media_query(:desktop_or_laptop, min_width: "1225px")
      |> assign_media_query(:portrait, orientation: "portrait")

    {:ok, socket}
  end
  ```
  """
  @spec assign_media_query(Socket.t(), atom(), list({atom(), number() | String.t() | boolean()})) ::
          Socket.t()
  def assign_media_query(socket, name, opts) do
    {initial, parsed_opts} = opts |> OptsParser.parse() |> OptsParser.pop("initial", false)
    query = QueryBuilder.build(parsed_opts)

    socket =
      if Map.has_key?(socket.assigns, @private_live_view_responsive_data) do
        socket
      else
        socket
        |> assign(@private_live_view_responsive_data, State.new())
        |> assign(@live_view_responsive_synced, false)
      end

    if Map.has_key?(socket.assigns, name) do
      raise "Cannot assign live_view_responsive query named #{name}, because assign with such name already exists."
    end

    socket
    |> get_state()
    |> State.put_query(name, query, initial)
    |> put_state_to_socket(socket)
    |> assign(name, initial)
    |> attach_hook()
  end

  @doc false
  def live_view_responsive_push_queries_to_client_handler(socket) do
    queries_names =
      socket
      |> get_state()
      |> State.get_queries_names()

    socket =
      socket
      |> get_state()
      |> State.set_status(:queries_pushed)
      |> put_state_to_socket(socket)
      |> push_event("live-view-responsive-sync", queries_names)

    {:noreply, socket}
  end

  @doc false
  def live_view_responsive_change_event_handler(socket, queries_values) do
    new_state =
      socket
      |> get_state()
      |> State.update_queries_values(queries_values)

    first_call = State.get_status(new_state) == :queries_pushed

    new_state = if first_call, do: State.set_status(new_state, :synced), else: new_state

    new_assigns =
      if(first_call, do: [{@live_view_responsive_synced, true}], else: []) ++
        [{@private_live_view_responsive_data, new_state}]

    new_assigns =
      Enum.reduce(new_state.queries, new_assigns, fn {name, %{value: value}}, acc ->
        Keyword.put(acc, name, value)
      end)

    send_update(
      socket.assigns.myself,
      new_assigns
    )

    # to make new assigns visible in tests
    socket = assign(socket, new_assigns)

    {:noreply, socket}
  end

  defp get_state(%Socket{} = socket) do
    get_state(socket.assigns)
  end

  defp get_state(assigns) do
    Map.fetch!(assigns, @private_live_view_responsive_data)
  end

  defp put_state_to_socket(state, socket) do
    assign(socket, @private_live_view_responsive_data, state)
  end

  defp attach_hook(socket) do
    if socket |> get_state() |> State.get_status() == :initial do
      socket
      |> get_state()
      |> State.set_status(:hook_attached)
      |> put_state_to_socket(socket)
      |> attach_hook(
        @private_live_view_responsive_after_render_hook,
        :after_render,
        &hook_handler/1
      )
    else
      socket
    end
  end

  defp hook_handler(socket) do
    if socket |> get_state() |> State.get_status() == :hook_attached do
      socket
      |> start_async(:live_view_responsive_push_queries_to_client, &noop/0)
      |> detach_hook(@private_live_view_responsive_after_render_hook, :after_render)
    else
      socket
    end
  end

  defp noop do
    nil
  end
end
