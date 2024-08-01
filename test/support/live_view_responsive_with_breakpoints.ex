defmodule LiveViewResponsive.LiveViewResponsiveWithBreakpoints do
  @moduledoc false

  use LiveViewResponsive.Breakpoints,
    mobile: [max_width: 700, initial: true],
    tablet: [min_width: 701, max_width: 1200],
    desktop: [min_width: 1201],
    portrait: [orientation: :portrait]
end
