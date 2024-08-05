defmodule ExampleApp.LiveViewResponsive do
  use LiveViewResponsive.Breakpoints, [
    sm: [min_width: 576],
    md: [min_width: 768],
    lg: [min_width: 992],
    portrait: [orientation: :portrait],
  ]
end
