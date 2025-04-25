defmodule ExampleAppWeb.E2E.HomePageE2ETest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias Wallaby.{Browser, Query}

  @breakpoints [
    %{name: "sm", width: 640, height: 800},
    %{name: "md", width: 768, height: 800},
    %{name: "lg", width: 1024, height: 800},
    %{name: "portrait", width: 600, height: 900},
    %{name: "landscape", width: 900, height: 600}
  ]

  feature "renders correct elements based on media query assigns for each breakpoint" do
    Enum.each(@breakpoints, fn %{name: name, width: width, height: height} ->
      {:ok, session} = Wallaby.start_session()
      session = Browser.resize_window(session, width, height)
      session = Browser.visit(session, "/")

      Browser.assert_has(session, Query.css("span[data-testid='assign-#{name}']"))

      @breakpoints
      |> Enum.filter(&(Map.get(&1, :width) > width and Map.get(&1, :height) > height))
      |> Enum.each(fn %{name: other_name} ->
        Browser.refute_has(session, Query.css("span[data-testid='assign-#{other_name}']"))
      end)
    end)
  end

  feature "renders correct elements based on media query components for each breakpoint" do
    Enum.each(@breakpoints, fn %{name: name, width: width, height: height} ->
      {:ok, session} = Wallaby.start_session()
      session = Browser.resize_window(session, width, height)
      session = Browser.visit(session, "/")

      Browser.assert_has(session, Query.css("span[data-testid='component-#{name}']"))

      @breakpoints
      |> Enum.filter(&(Map.get(&1, :width) > width and Map.get(&1, :height) > height))
      |> Enum.each(fn %{name: other_name} ->
        Browser.refute_has(session, Query.css("span[data-testid='component-#{other_name}']"))
      end)
    end)
  end
end
