defmodule UnchartedPhoenix.Components.ChartLines do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.Chart

  def chart_lines(assigns) do
    ~H"""
    <% %{display_lines: display, line_color: color, line_width: width} = @axis %>
    <% colors = Chart.colors(@chart) %>
    <%= if display do %>
      <g id={svg_id(@chart, "lines")} class="chart-lines">
        <line x1="0%" y1="0%" x2="0%" y2="100%" stroke={color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
        <line x1="0%" y1="100%" x2="100%" y2="100%" stroke={color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
        <%= for line <- @grid_lines do %>
          <% offset = @offsetter.(line) %>
          <line x1="0%" y1={"#{offset}%"} x2="100%" y2={"#{offset}%"} stroke={color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
        <% end %>
        <line x1="0%" y1="0%" x2="100%" y2="0%" stroke={color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
        <line x1="100%" y1="0%" x2="100%" y2="100%" stroke={color_to_fill(colors, color, true)} stroke-width={"#{width}px"} stroke-linecap="round" />
      </g>
    <% end %>
    """
  end
end
