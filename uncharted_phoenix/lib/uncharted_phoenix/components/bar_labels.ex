defmodule UnchartedPhoenix.Components.BarLabels do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers

  def bar_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "ylabels")} class="chart-y-labels" width="10%" height="92%" y="0" x="0"  overflow="visible">
      <%= for %Uncharted.BarChart.Bar{label: label, bar_offset: bar_offset, bar_height: bar_height} <- Uncharted.BarChart.bars(@chart) do %>
        <foreignObject x="0" y={"#{bar_offset}%"} height={"#{bar_height}%"} width="100%">
          <p xmlns="http://www.w3.org/1999/xhtml" title={label} style="font-size:9px; overflow: hidden; text-overflow: ellipsis;">
            <%= label %>
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end
end
