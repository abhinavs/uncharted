defmodule UnchartedPhoenix.Components.FunnelBars do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.Chart

  def funnel_bars(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "bars")} width="96%" height="100%" x="2%" y="0">
      <%= for %{sections: sections} <- @bars do %>
        <%= for %{label: label, fill_color: fill_color, x_points: [x_left, x_right, x_lower_right, x_lower_left], y_points: [y_top, y_middle, y_bottom]} <- sections do %>
          <g class="chart-bar">
            <path
              d={"M#{x_left},#{y_top} L#{x_right},#{y_top} C#{x_right},#{y_middle},#{x_lower_right},#{y_middle},#{x_lower_right},#{y_bottom} L#{x_lower_left},#{y_bottom} C#{x_lower_left},#{y_middle},#{x_left},#{y_middle},#{x_left},#{y_top}z"}
              id={label}
              fill={color_to_fill(Chart.colors(@chart), fill_color)}
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
