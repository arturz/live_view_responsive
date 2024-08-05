defmodule LiveViewResponsive.CoreTest do
  @moduledoc false

  use LiveViewResponsive.ConnCase

  describe "assign_media_query/2" do
    test "assigns initial value", %{conn: conn} do
      {:ok, _view, html} = live_isolated(conn, LiveViewResponsive.AssignMediaQueryTestLiveView)

      assert html =~ "#1 landscape"
      assert html =~ "#2 landscape"
      assert html =~ "#1 small screen"
      assert html =~ "#2 small screen"
    end

    test "both live components send all media queries to JS hooks", %{conn: conn} do
      {:ok, view, _html} = live_isolated(conn, LiveViewResponsive.AssignMediaQueryTestLiveView)

      for _ <- 1..2 do
        assert_push_event(view, "live-view-responsive-sync", %{
          sm: "(max-width: 640px)",
          is_portrait: "(orientation: portrait)",
          md: "(min-width: 641px) and (max-width: 1024px)",
          lg: "(min-width: 1025px)"
        })
      end
    end
  end

  describe "live_view_responsive_change_event_handler/2" do
    test "updates media queries in a single component", %{conn: conn} do
      {:ok, view, html} = live_isolated(conn, LiveViewResponsive.AssignMediaQueryTestLiveView)

      assert html =~ "#1 medium screen" == false
      assert html =~ "#2 medium screen" == false

      html =
        view
        |> element("[data-phx-component=1] > [phx-hook=LiveViewResponsiveHook]")
        |> render_hook("live-view-responsive-change", %{"md" => true})

      assert html =~ "#1 medium screen"
      assert html =~ "#2 medium screen" == false
    end

    test "updates multiple media queries", %{conn: conn} do
      {:ok, view, html} = live_isolated(conn, LiveViewResponsive.AssignMediaQueryTestLiveView)

      assert html =~ "#1 landscape"
      assert html =~ "#1 small screen"
      assert html =~ "#1 medium screen" == false

      html =
        view
        |> element("[data-phx-component=1] > [phx-hook=LiveViewResponsiveHook]")
        |> render_hook("live-view-responsive-change", %{
          "is_portrait" => true,
          "sm" => false,
          "md" => true,
          "lg" => true
        })

      assert html =~ "#1 portrait"
      assert html =~ "#1 small screen" == false
      assert html =~ "#1 medium screen"
      assert html =~ "#1 large screen"
    end
  end
end
