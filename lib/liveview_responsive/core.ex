defmodule LiveviewResponsive.Core do
  @moduledoc false

  # < 0.18.0 assign/2 and assign/3 were inside Phoenix.LiveView
  import Phoenix.LiveView
  import Phoenix.Component

  alias Phoenix.LiveView.Socket

  alias LiveviewResponsive.State
  alias LiveviewResponsive.QueryBuilder

  def assign_media_query(socket, name, opts, default_value \\ false) do
    query = QueryBuilder.build(opts)

    socket =
      if Map.has_key?(socket.assigns, :private_liveview_responsive_data) do
        socket
      else
        assign(socket, :private_liveview_responsive_data, State.new())
      end

    if Map.has_key?(socket.assigns, name) do
      raise "Cannot assign liveview-responsive query named #{name}, because assign with such name already exists."
    end

    socket
    |> get_state()
    |> State.put_query(name, query, default_value)
    |> put_state_to_socket(socket)
    |> assign(name, default_value)
    |> attach_hook()
  end

  def liveview_responsive_synced?(assigns) do
    assigns
    |> get_state()
    |> State.get_status() == :synced
  end

  def liveview_responsive_start_sync_async_handler(socket) do
    queries_names =
      socket
      |> get_state()
      |> State.get_queries_names()

    socket =
      socket
      |> get_state()
      |> State.set_status(:synced)
      |> put_state_to_socket(socket)
      |> push_event("liveview-responsive-sync", queries_names)

    {:noreply, socket}
  end

  def liveview_responsive_change_event_handler(socket, queries_values) do
    new_state =
      socket
      |> get_state()
      |> State.update_queries_values(queries_values)

    new_assigns = [
      private_liveview_responsive_data: new_state
    ]

    new_assigns =
      Enum.reduce(new_state.queries, new_assigns, fn {name, %{value: value}}, acc ->
        Keyword.put(acc, name, value)
      end)

    send_update(
      socket.assigns.myself,
      new_assigns
    )

    {:noreply, socket}
  end

  defp get_state(%Socket{} = socket) do
    get_state(socket.assigns)
  end

  defp get_state(assigns) do
    assigns.private_liveview_responsive_data
  end

  defp put_state_to_socket(state, socket) do
    assign(socket, :private_liveview_responsive_data, state)
  end

  defp attach_hook(socket) do
    if socket |> get_state() |> State.get_status() == :initial do
      socket
      |> get_state()
      |> State.set_status(:hook_attached)
      |> put_state_to_socket(socket)
      |> attach_hook(
        :private_liveview_responsive_after_render_hook,
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
      |> get_state()
      |> State.set_status(:hook_runned)
      |> put_state_to_socket(socket)
      |> start_async(:liveview_responsive_start_sync, &noop/0)
      |> detach_hook(:private_liveview_responsive_after_render_hook, :after_render)
    else
      socket
    end
  end

  defp noop do
    nil
  end
end
