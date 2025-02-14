defmodule UnchartedPhoenix.Components.Bars do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.Chart

  def bars(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "bars")} width="96%" height="100%" x="2%" y="0">
      <%= for %{bar_height: bar_height, bar_offset: bar_offset, sections: sections} <- @bars do %>
        <%= for %{offset: section_offset, label: label, fill_color: fill_color, bar_width: bar_width} <- sections do %>
          <g class="chart-bar">
            <rect
              id={label}
              width={"#{bar_width}%"}
              height={"#{bar_height}%"}
              x={"#{section_offset}%"}
              y={"#{bar_offset}%"}
              rx="10"
              ry="10"
              fill={color_to_fill(Chart.colors(@chart), fill_color) }
              style="transition: all 1s ease;">
                <animate attributeName="width" values="0%;30%" dur="1s" repeatCount="freeze" />
            </rect>
          </g>
        <% end %>
      <% end %>
    </svg>
    """
  end
end
