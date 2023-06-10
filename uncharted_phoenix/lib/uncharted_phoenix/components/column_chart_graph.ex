defmodule UnchartedPhoenix.Components.ColumnChartGraph do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.ColumnChart.{ColumnSection, Column}

  def column_chart_grap(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "results")} class="chart-results" width="100%" height="96%" x="0%" y="2%">
      <g>
        <%= for %Column{bar_width: bar_width, bar_offset: bar_offset, sections: sections} <- @columns do %>
          <%= for %ColumnSection{offset: section_offset, label: label, fill_color: fill_color, column_height: column_height} <- sections do %>
            <rect id={label}
                  class="chart-column-section"
                  width={"#{bar_width}%"}
                  height={"#{column_height}%"}
                  x={"#{bar_offset}%"}
                  y={"#{100 - section_offset}%"}
                  rx="10"
                  ry="10"
                  style="transition: all 1s ease;"
                  fill={color_to_fill(@chart.colors(), fill_color)}
                >
              <animate attributeName="height" values="0;30%" dur="1s" repeatCount="freeze" />
              <animate attributeName="y" values="100%;70%" dur="1s" repeatCount="freeze" />
            </rect>
          <% end %>
        <% end %>
      </g>
    </svg>
    """
  end
end
