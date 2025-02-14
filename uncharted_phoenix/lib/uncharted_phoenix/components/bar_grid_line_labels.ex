defmodule UnchartedPhoenix.Components.BarGridLineLabels do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers

  def bar_grid_line_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "xlabels")} class="chart-x-labels" width="90%" height="8%" y="92%" x="0" overflow="visible" viewBox="0 0 100% 100%">
      <% label_width = 100 / Enum.count(@grid_lines)%>
      <%= for grid_line <- @grid_lines do %>
        <% offset = @offsetter.(grid_line) %>
        <foreignObject x={"#{offset}%"} y="10%" height="100%" width={"#{label_width}%"} style="overflow: visible;">
          <p xmlns="http://www.w3.org/1999/xhtml" title={grid_line} style="font-size: 9px; text-align: center; padding: 0 10%; overflow: hidden; text-overflow: ellipsis;">
            <%= grid_line %>
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end

end
