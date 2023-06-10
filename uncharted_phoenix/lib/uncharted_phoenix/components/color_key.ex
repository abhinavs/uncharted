defmodule UnchartedPhoenix.Components.ColorKey do
  use Phoenix.Component
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.Section

  def color_key(assigns) do
    ~H"""
    <%= for %Section{fill_color: fill_color, label: label, index: index} <- Enum.sort_by(@chart.dataset.sections, &(&1.index)) do %>
      <g>
        <rect id={"#{label}_key"}
                class="chart-color-key"
                width="5%"
                height="50%"
                x={"#{center_key(Enum.count(@chart.dataset.sections), index)}%"}
                y="0%"
                rx="10"
                ry="10"
                style="transition: all 1s ease;"
                fill={color_to_fill(@chart.colors(), fill_color)}
              />
      </g>
      <foreignObject y="52%" x={"#{center_key(Enum.count(@chart.dataset.sections), index)}%"} width="5%" height="100%"  overflow="visible">
        <p xmlns="http://www.w3.org/1999/xhtml" title={label} style="font-size:9px; text-align: center; padding: 0 10%; overflow: hidden; text-overflow: ellipsis;">
          <%= label %>
        </p>
      </foreignObject>
    <% end %>
    """
  end
end
