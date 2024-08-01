defmodule LiveViewResponsive.Case do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      use ExUnit.Case, async: true

      import ExUnit.CaptureIO
      import ExUnit.CaptureLog

      import Phoenix.LiveViewTest
    end
  end
end
