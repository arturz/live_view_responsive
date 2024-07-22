defmodule LiveviewResponsive.State do
  @type t :: %__MODULE__{
          queries: %{atom() => %{value: boolean(), query: String.t()}},
          status: :initial | :hook_attached | :hook_runned | :synced
        }
  defstruct queries: %{}, status: :initial

  require Logger

  def new do
    %__MODULE__{}
  end

  def get_status(%__MODULE__{} = state) do
    state.status
  end

  def set_status(%__MODULE__{status: :initial} = state, :hook_attached) do
    Logger.debug("LiveviewResponsive.State.set_status: hook_attached")

    Map.put(state, :status, :hook_attached)
  end

  def set_status(%__MODULE__{status: :hook_attached} = state, :hook_runned) do
    Logger.debug("LiveviewResponsive.State.set_status: hook_runned")

    Map.put(state, :status, :hook_runned)
  end

  def set_status(%__MODULE__{status: :hook_runned} = state, :synced) do
    Logger.debug("LiveviewResponsive.State.set_status: synced")

    Map.put(state, :status, :synced)
  end

  def put_query(%__MODULE__{} = state, name, query, value) do
    put_in(state, [Access.key(:queries), name], %{
      query: query,
      value: value
    })
  end

  def get_queries_names(%__MODULE__{} = state) do
    Enum.reduce(state.queries, %{}, fn {name, %{query: query}}, acc ->
      Map.put(acc, name, query)
    end)
  end

  @spec update_queries_values(t(), %{String.t() => boolean()}) :: t()
  def update_queries_values(%__MODULE__{} = state, queries_values) do
    queries_values =
      Enum.map(queries_values, fn {name, new_value} ->
        {String.to_existing_atom(name), new_value}
      end)

    Enum.reduce(queries_values, state, fn {name, new_value}, state ->
      case Map.get(state.queries, name) do
        nil -> state
        %{value: value} when value === new_value -> state
        _ -> put_in(state, [Access.key(:queries), name, Access.key(:value)], new_value)
      end
    end)
  end
end
