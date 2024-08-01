defmodule LiveViewResponsive.Components.MediaQueryTest do
  @moduledoc false

  use LiveViewResponsive.Case

  import Phoenix.Component
  import LiveViewResponsive

  describe "<.media_query />" do
    test "works with attributes" do
      assert render_component(&attributes_test/1) |> renders_query?()
    end

    test "works with custom query" do
      assert render_component(&query_test/1) |> renders_query?()
    end

    test "renders phx-hook attribute" do
      assert render_component(&query_test/1) =~
               "phx-hook=\"LiveViewResponsiveMediaQueryHook\""
    end
  end

  defp renders_query?(html) do
    html =~ "data-query=\"screen and (orientation: portrait)\"" or
      html =~ "data-query=\"(orientation: portrait) and screen\""
  end

  defp attributes_test(assigns) do
    ~H"""
    <.media_query screen orientation="portrait">
      <p>Portrait</p>
    </.media_query>
    """
  end

  defp query_test(assigns) do
    ~H"""
    <.media_query query="screen and (orientation: portrait)">
      <p>Portrait</p>
    </.media_query>
    """
  end
end
