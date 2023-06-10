defmodule UnchartedPhoenix.Components.FunnelChartValueLabels do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers

  def funnel_chart_value_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "xlabelsvalues")} class="chart-x-labels" width="90.5%" height="8%" y="0" x="0" overflow="visible">
      <%= for %{full_bar_value: value, label: label, full_bar_percentage: percentage, offset: bar_offset, width: bar_width} <- @columns do %>
        <foreignObject y="20%" x={"#{bar_offset}%"} width={"#{bar_width}%"} height="100%"  overflow="visible">
          <p xmlns="http://www.w3.org/1999/xhtml" title={label} style="font-size:9px; text-align: left; padding: 0 10% 0 0; overflow: hidden; text-overflow: ellipsis;">
            <%= value %> / <%= Float.round(percentage, 2) %>%
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end
end
