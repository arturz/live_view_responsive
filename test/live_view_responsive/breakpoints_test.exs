defmodule LiveViewResponsive.BreakpointsTest do
  @moduledoc false

  use LiveViewResponsive.ConnCase

  describe "breakpoints" do
    test "media query values are by default false", %{conn: conn} do
      {:ok, _view, html} = live_isolated(conn, LiveViewResponsive.BreakpointsTestLiveView)

      assert html =~ "#1 desktop" == false
      assert html =~ "#2 desktop" == false
    end

    test "allows setting initial media query value in breakpoints definition module", %{
      conn: conn
    } do
      {:ok, _view, html} = live_isolated(conn, LiveViewResponsive.BreakpointsTestLiveView)

      assert html =~ "#1 mobile"
      assert html =~ "#2 mobile"
    end

    test "allows setting initial media query value with `assign_media_query_{name}(socket, initial: true)` function calls",
         %{conn: conn} do
      {:ok, _view, html} = live_isolated(conn, LiveViewResponsive.BreakpointsTestLiveView)

      assert html =~ "#1 tablet"
      assert html =~ "#2 tablet"
    end

    test "both live components send all media queries to JS hooks", %{conn: conn} do
      {:ok, view, _html} = live_isolated(conn, LiveViewResponsive.BreakpointsTestLiveView)

      for _ <- 1..2 do
        assert_push_event(view, "liveview-responsive-sync", %{
          desktop: "(min-width: 1201px)",
          mobile: "(max-width: 700px)",
          tablet: "(min-width: 701px) and (max-width: 1200px)"
        })
      end
    end

    test "updates media queries in a single component", %{conn: conn} do
      {:ok, view, html} = live_isolated(conn, LiveViewResponsive.BreakpointsTestLiveView)

      assert html =~ "#1 mobile"
      assert html =~ "#2 mobile"
      assert html =~ "#1 desktop" == false
      assert html =~ "#2 desktop" == false

      html =
        view
        |> element("[data-phx-component=1] > [phx-hook=LiveViewResponsiveHook]")
        |> render_hook("liveview-responsive-change", %{"desktop" => true, "mobile" => false})

      assert html =~ "#1 mobile" == false
      assert html =~ "#2 mobile"
      assert html =~ "#1 desktop"
      assert html =~ "#2 desktop" == false
    end
  end
end
