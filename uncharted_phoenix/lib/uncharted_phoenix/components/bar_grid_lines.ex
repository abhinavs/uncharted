defmodule UnchartedPhoenix.Components.BarGridLines do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.Chart

  def bar_grid_lines(assigns) do
    ~H"""
    <% %{display_lines: display, line_color: color, line_width: width} = @axis %>
    <% colors = Chart.colors(@chart) %>
    <%= if display do %>
      <g class="chart-lines">
        <line x1="0%" y1="0%" x2="0%" y2="100%" stroke={color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
        <line x1="0%" y1="100%" x2="100%" y2="100%" stroke={ color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
        <%= for grid_line <- @grid_lines do %>
          <% offset = @offsetter.(grid_line) %>
          <line x1={"#{offset}%"} y1="0%" x2={"#{offset}%"} y2="100%" stroke={color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
        <% end %>
        <line x1="0%" y1="0%" x2="100%" y2="0%" stroke={ color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
        <line x1="100%" y1="0%" x2="100%" y2="100%" stroke={ color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
      </g>
    <% end %>
    """
  end

end
