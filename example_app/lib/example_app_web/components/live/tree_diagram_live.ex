defmodule ExampleAppWeb.Components.Live.TreeDiagramLive do
  @moduledoc """
  Renders a tree diagram using LiveViewResponsive. Node and row names are in English.
  """

  use ExampleAppWeb, :live_component
  use LiveViewResponsive
  require Logger

  @impl true
  def mount(socket) do
    tree_data = [
      [%{id: 1, template: %{name: "First row"}, children_ids: [2, 3, 5]}],
      [
        %{id: 2, template: %{name: "Second row"}, children_ids: [6]},
        %{id: 3, template: %{name: "Second row"}, children_ids: [7]},
        %{id: 4, template: %{name: "Second row"}, children_ids: [8]},
        %{id: 5, template: %{name: "Second row"}, children_ids: [9]}
      ],
      [
        %{id: 6, template: %{name: "Third row"}, children_ids: [10]},
        %{id: 7, template: %{name: "Third row"}, children_ids: [10]},
        %{id: 8, template: %{name: "Third row"}, children_ids: [10]},
        %{id: 9, template: %{name: "Third row"}, children_ids: [10]}
      ],
      [%{id: 10, template: %{name: "Fourth row"}, children_ids: []}]
    ]

    socket =
      socket
      |> assign(:tree, tree_data)
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
  def render(assigns) do
    ~H"""
    <div>
      <.live_view_responsive myself={@myself} />
      <div :if={@live_view_responsive_synced} id={@id} class="flex flex-col gap-12">
        <div :for={tree_row <- @tree} class="flex justify-center gap-12">
          <%= if length(tree_row) <= @columns_count do %>
            <div
              :for={node <- tree_row}
              class="workflow-template card card-border w-44 h-20 flex justify-center items-center text-center"
              data-id={node.id}
              data-children-ids={Jason.encode!(node.children_ids)}
            >
              <div class="card-body">
                <%= node.template.name %>
              </div>
            </div>
          <% else %>
            <% first_node = Enum.at(tree_row, 0) %>
            <div
              class="workflow-template card card-border w-44 h-20 flex justify-center items-center text-center"
              data-id={first_node.id}
              data-children-ids={Jason.encode!(first_node.children_ids)}
            >
              <div class="card-body">
                <%= first_node.template.name %>
              </div>
            </div>
            <div
              class="workflow-template-connector card card-border w-20 h-20 flex justify-center items-center text-center"
              data-n={length(tree_row) - 2}
              data-siblings-ids={Jason.encode!([Enum.at(tree_row, 0).id, Enum.at(tree_row, -1).id])}
            >
              <div class="card-body">
                <%= "1..#{length(tree_row) - 2}" %>
              </div>
            </div>
            <% last_node = Enum.at(tree_row, -1) %>
            <div
              class="workflow-template card card-border w-44 h-20 flex justify-center items-center text-center"
              data-id={last_node.id}
              data-children-ids={Jason.encode!(last_node.children_ids)}
            >
              <div class="card-body">
                <%= last_node.template.name %>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
