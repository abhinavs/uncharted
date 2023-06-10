defmodule UnchartedPhoenix.Components.FunnelChartGraph do

  def funnel_chart_graph(assigns) do
    ~H"""
    <svg id"<%= svg_id(@chart, "results") %>" class="chart-results" width="100%" height="96%" x="0%" y="2%">
      <%= for %{sections: sections} <- @columns do %>
        <%= for %{label: label, fill_color: fill_color, y_points: [y_bottom, y_top, y_right_top, y_right_bottom], x_points: [x_left, x_middle, x_right]} <- sections do %>
          <g class="chart-bar">
            <path
              d="M<%= x_left %>,<%= y_bottom %> L<%= x_left %>,<%= y_top %> C<%= x_middle %>,<%= y_top %>,<%= x_middle %>,<%= y_right_top %>,<%= x_right %>,<%= y_right_top %> L<%= x_right %>,<%= y_right_bottom %> C<%= x_middle %>,<%= y_right_bottom %>,<%= x_middle %>,<%= y_bottom %>,<%= x_left %>,<%= y_bottom %>z"
              id="<%= label %>"
              fill="<%= color_to_fill(Chart.colors(@chart), fill_color)  %>"
              style="transition: all 1s ease; stroke-linejoin: round;">
                <animate attributeName="width" values="0%;30%" dur="1s" repeatCount="freeze" />
            </path>
          </g>
        <% end %>
      <% end %>
    </svg>
    """
  end
end
