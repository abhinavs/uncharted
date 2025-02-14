defmodule UnchartedPhoenix.Components.XAxix do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers

  def x_axis(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "xlabels")} class="chart-x-labels" width="90.5%" height="8%" y="92%" x="9.5%" overflow="visible" >
      <%= for %{label: label, width: width, offset: offset} <- @columns do %>
        <foreignObject y="20%" x={"#{offset}%"} width={"#{width}%"} height="100%"  overflow="visible">
          <p xmlns="http://www.w3.org/1999/xhtml" title={label} style="font-size:9px; text-align: center; padding: 0 10%; overflow: hidden; text-overflow: ellipsis;">
            <%= label %>
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end
end
