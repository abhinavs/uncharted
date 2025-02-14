defmodule UnchartedPhoenix.Components.YAxix do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers

  def y_axis(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "ylabels")} class="chart-y-labels" width="10%" height="90%" y="0" x="0" overflow="visible">
      <%= for grid_line <- @grid_lines do %>
        <foreignObject x="0" y={"#{@offsetter.(grid_line)}%"} height="20px" width="100%"  overflow="visible">
          <p xmlns="http://www.w3.org/1999/xhtml" title={grid_line} style="font-size: 9px; padding-bottom:20%; overflow:hidden; text-overflow: ellipsis;">
            <%= grid_line %>
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end
end
