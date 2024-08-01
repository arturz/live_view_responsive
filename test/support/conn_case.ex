defmodule LiveViewResponsive.ConnCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  defmacro __using__(_opts) do
    quote do
      @endpoint LiveViewResponsive.Endpoint

      use ExUnit.Case, async: true

      import Plug.Conn
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest
      import LiveViewResponsive.ConnCase

      setup do
        {:ok, conn: Phoenix.ConnTest.build_conn()}
      end
    end
  end
end
