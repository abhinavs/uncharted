defmodule UnchartedPhoenix.Components.FunnelBarValueLabels do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers

  def funnel_bar_value_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "ylabelsvalues")} class="chart-y-labels" width="10%" height="92%" y="0" x="90%"  overflow="visible">
      <%= for %{full_bar_value: value, full_bar_percentage: percentage, offset: bar_offset, bar_height: bar_height} <- @bars do %>
        <foreignObject x="0" y={"#{bar_offset}%"} height={"#{bar_height}%"} width="100%">
          <p xmlns="http://www.w3.org/1999/xhtml" title={value} style="font-size:9px; overflow: hidden; text-overflow: ellipsis;">
            <%= value %> / <%= Float.round(percentage, 2) %>%
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end
end
