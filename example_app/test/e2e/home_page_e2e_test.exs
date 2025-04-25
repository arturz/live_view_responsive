defmodule ExampleAppWeb.E2E.HomePageE2ETest do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  alias Wallaby.{Browser, Query}

  feature "home page loads and displays main content", %{session: session} do
    session
    |> Browser.visit("/")
    |> Browser.assert_has(Query.css("body", text: "Device Test"))
  end

  @breakpoints [
    %{name: "sm", width: 640, height: 800, assign: "sm"},
    %{name: "md", width: 768, height: 800, assign: "md"},
    %{name: "lg", width: 1024, height: 800, assign: "lg"},
    %{name: "portrait", width: 600, height: 900, assign: "portrait"},
    %{name: "landscape", width: 900, height: 600, assign: "landscape"}
  ]

  feature "renders correct elements based on media query assigns for each breakpoint", %{session: session} do
    Enum.each(@breakpoints, fn %{name: name, width: width, height: height, assign: assign} ->
      session = Browser.resize_window(session, width, height)
      session = Browser.visit(session, "/")

      assert Browser.has?(session, Query.css("span[data-testid='assign-#{assign}']"))

      @breakpoints
      |> Enum.filter(& Map.get(&1, :width) > width and Map.get(&1, :height) > height)
      |> Enum.each(fn %{assign: other_assign} ->
        refute Browser.has?(session, Query.css("span[data-testid='assign-#{other_assign}']"))
      end)
    end)
  end

  feature "renders correct elements based on media query components for each breakpoint", %{session: session} do
    Enum.each(@breakpoints, fn %{name: name, width: width, height: height, assign: assign} ->
      session = Browser.resize_window(session, width, height)
      session = Browser.visit(session, "/")

      assert Browser.has?(session, Query.css("span[data-testid='component-#{name}']"))

      @breakpoints
      |> Enum.filter(& Map.get(&1, :width) > width and Map.get(&1, :height) > height)
      |> Enum.each(fn %{name: other_name} ->
        refute Browser.has?(session, Query.css("span[data-testid='component-#{other_name}']"))
      end)
    end)
  end
end
