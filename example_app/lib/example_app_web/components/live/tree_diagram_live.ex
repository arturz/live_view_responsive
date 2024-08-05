defmodule ExampleAppWeb.Components.Live.TreeDiagramLive do
    @moduledoc false

    use ExampleAppWeb, :live_component

    use LiveViewResponsive

    require Logger

    @impl true
    def mount(socket) do
      socket =
        socket
        |> assign(:tree, [
          [%{id: 1, template: %{name: "Pierwszy wiersz"}, children_ids: [2, 3, 5]}],
          [
            %{id: 2, template: %{name: "Drugi wiersz"}, children_ids: [6]},
            %{id: 3, template: %{name: "Drugi wiersz"}, children_ids: [7]},
            %{id: 4, template: %{name: "Drugi wiersz"}, children_ids: [8]},
            %{id: 5, template: %{name: "Drugi wiersz"}, children_ids: [9]},
          ],
          [
            %{id: 6, template: %{name: "Trzeci wiersz"}, children_ids: [10]},
            %{id: 7, template: %{name: "Trzeci wiersz"}, children_ids: [10]},
            %{id: 8, template: %{name: "Trzeci wiersz"}, children_ids: [10]},
            %{id: 9, template: %{name: "Trzeci wiersz"}, children_ids: [10]}
          ],
          [%{id: 10, template: %{name: "Czwarty wiersz"}, children_ids: []}]
        ])
        |> assign_media_query(:xl, min_width: 1400)
        |> assign_media_query(:lg, min_width: 1000)

      {:ok, socket}
    end

    @impl true
    def update(assigns, socket) do
      columns_count =
        cond do
          Map.get(assigns, :xl) -> 7
          Map.get(assigns, :lg) -> 5
          true -> 3
        end

      socket = assign(socket, :columns_count, columns_count)

      {:ok, assign(socket, assigns)}
    end

    @impl true
    @spec render(atom() | %{:columns_count => any(), optional(any()) => any()}) ::
            Phoenix.LiveView.Rendered.t()
    def render(assigns) do
      ~H"""
      <div>
        <.live_view_responsive myself={@myself} />

        <.media_query max-width={1224}>
          <p>You are on a tablet or mobile</p>
        </.media_query>
        <.media_query min-width={1225}>
          <p>You are on a desktop or laptop</p>
          <.media_query min-width="1400px">
            <p>You also have a huge screen</p>
          </.media_query>
        </.media_query>

        <.media_query orientation="portrait">
          <p>You are in portrait mode</p>
        </.media_query>

        <.media_query min-resolution="2dppx">
          <p>You are on a retina screen</p>
        </.media_query>

        <div :if={@xl}>xl</div>
        <div :if={@lg}>lg</div>

        <div id={@id} class="flex flex-col gap-12" :if={@live_view_responsive_synced}>
          <div :for={row <- @tree} class="flex justify-center gap-12">
            <%= if length(row) <= @columns_count do %>
              <div
                :for={cell <- row}
                class="workflow-template card card-border w-44 h-20 flex justify-center items-center text-center"
                data-id={cell.id}
                data-children-ids={Jason.encode!(cell.children_ids)}
              >
                <div class="card-body">
                  <%= cell.template.name %>
                </div>
              </div>
            <% else %>
              <% cell = Enum.at(row, 0) %>
              <div
                class="workflow-template card card-border w-44 h-20 flex justify-center items-center text-center"
                data-id={cell.id}
                data-children-ids={Jason.encode!(cell.children_ids)}
              >
                <div class="card-body">
                  <%= cell.template.name %>
                </div>
              </div>
              <div
                class="workflow-template-connector card card-border w-20 h-20 flex justify-center items-center text-center"
                data-n={length(row) - 2}
                data-siblings-ids={Jason.encode!([Enum.at(row, 0).id, Enum.at(row, -1).id])}
              >
                <div class="card-body">
                  <%= "1..#{length(row) - 2}" %>
                </div>
              </div>
              <% cell = Enum.at(row, -1) %>
              <div
                class="workflow-template card card-border w-44 h-20 flex justify-center items-center text-center"
                data-id={cell.id}
                data-children-ids={Jason.encode!(cell.children_ids)}
              >
                <div class="card-body">
                  <%= cell.template.name %>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
      """
    end
end
