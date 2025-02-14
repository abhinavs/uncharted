defmodule UnchartedPhoenix.Components.FunnelChartXAxis do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.ColumnChart.Column

  def funnel_chart_x_axis(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "xlabels")} class="chart-x-labels" width="90.5%" height="8%" y="92%" x="9.5%">
      <%= for %Column{label: label, width: width, offset: offset} <- @columns do %>
        <svg x={"#{offset}%"} y="0%" height="100%" width={"#{width}%"} >
          <svg width="100%" height="100%">
            <text x="50%" y="50%" alignment-baseline="middle" text-anchor="middle"><%= label %></text>
          </svg>
        </svg>
      <% end %>
    </svg>
    """
  end
end
