defmodule UnchartedPhoenix.Components.ComponentHelpers do

  use Phoenix.Component
  alias Uncharted.{Chart, Gradient, Section}
  alias Uncharted.ColumnChart.{Column, ColumnSection}
  alias Uncharted.LineChart.{Line, Point}
  alias Uncharted.ScatterPlot.Point, as: ScatterPoint

  def color_to_fill(colors, name, is_line \\ false) do
    case Map.get(colors, name, nil) do
      %Gradient{} -> "url(##{Atom.to_string(name) <> if is_line, do: "_line", else: ""})"
      nil -> name
      value -> value
    end
  end

  def svg_id(chart, suffix) do
    base =
      chart
      |> Chart.title()
      |> String.downcase()
      |> String.replace(~r(\s+), "-")

    base <> "-" <> suffix
  end

  def svg_pie_slices(nil), do: []
  def svg_pie_slices([]), do: []

  def svg_pie_slices(pie_slices) do
    label_width = 100 / Enum.count(pie_slices)

    pie_slices
    |> Enum.with_index()
    |> Enum.reduce([], fn {pie_slice, index}, acc ->
      remaining_percentage =
        100 - Enum.reduce(acc, 0, fn slice, sum -> sum + slice.percentage end)

      svg_slice =
        pie_slice
        |> Map.from_struct()
        |> Map.put(:remaining_percentage, remaining_percentage)
        |> Map.put(:label_width, label_width)
        |> Map.put(:label_position, index * label_width)

      [svg_slice | acc]
    end)
    |> Enum.reverse()
  end

  def svg_doughnut_slices(nil), do: []
  def svg_doughnut_slices([]), do: []

  def svg_doughnut_slices(doughnut_slices) do
    label_width = 100 / Enum.count(doughnut_slices)

    doughnut_slices
    |> Enum.with_index()
    |> Enum.reduce([], fn {doughnut_slice, index}, acc ->
      remaining_percentage =
        100 - Enum.reduce(acc, 0, fn slice, sum -> sum + slice.percentage end)

      svg_slice =
        doughnut_slice
        |> Map.from_struct()
        |> Map.put(:remaining_percentage, remaining_percentage)
        |> Map.put(:label_width, label_width)
        |> Map.put(:label_position, index * label_width)

      [svg_slice | acc]
    end)
    |> Enum.reverse()
  end

  def svg_polyline_points([]), do: ""

  def svg_polyline_points(points) do
    points
    |> Enum.map(fn %Point{x_offset: x, y_offset: y} -> "#{10 * x},#{1000 - 10 * y}" end)
    |> List.insert_at(0, "#{hd(points).x_offset * 10},1000")
    |> List.insert_at(-1, "#{List.last(points).x_offset * 10},1000")
    |> Enum.join(" ")
  end

  def maybe_show_table(true), do: []

  def maybe_show_table(_),
    do: [
      style:
        "position: absolute; left: -100000px; top: auto; height: 1px; width: 1px; overflow: hidden;"
    ]

  def center_key(section_count, index) do
    key_section_placement(index) + key_offset(section_count)
  end

  defp key_section_placement(index), do: index * 12

  defp key_offset(section_count), do: (100 - key_width(section_count)) / 2

  defp key_width(section_count), do: section_count * 12 - 7

  def bar_grid_line_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "xlabels")} class="chart-x-labels" width="90%" height="8%" y="92%" x="0" overflow="visible" viewBox="0 0 100% 100%">
      <% label_width = 100 / Enum.count(@grid_lines)%>
      <%= for grid_line <- @grid_lines do %>
        <% offset = @offsetter.(grid_line) %>
        <foreignObject x={"#{offset}%"} y="10%" height="100%" width={"#{label_width}%"} style="overflow: visible;">
          <p xmlns="http://www.w3.org/1999/xhtml" title={grid_line} style="font-size: 9px; text-align: center; padding: 0 10%; overflow: hidden; text-overflow: ellipsis;">
            <%= grid_line %>
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end

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

  def color_defs(assigns) do
    ~H"""
    <defs>
      <%= for {name, %Uncharted.Gradient{start_color: start_color, stop_color: stop_color}} <- Chart.gradient_colors(@chart) do %>
        <linearGradient id={Atom.to_string(name)}>
          <stop stop-color={start_color} offset="0%"></stop>
          <stop stop-color={stop_color} offset="100%"></stop>
        </linearGradient>
        <linearGradient id={"#{Atom.to_string(name)}_line"} gradientUnits="userSpaceOnUse">
          <stop stop-color={start_color} offset="0%"></stop>
          <stop stop-color={stop_color} offset="100%"></stop>
        </linearGradient>
      <% end %>
    </defs>
    """
  end

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


  def column_chart_graph(assigns) do
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

  def funnel_bar_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "ylabels")} class="chart-y-labels" width="10%" height="92%" y="0" x="0"  overflow="visible">
      <%= for %{label: label, offset: bar_offset, bar_height: bar_height} <- @bars do %>
        <foreignObject x="0" y={"#{bar_offset}%"} height={"#{bar_height}%"} width="100%">
          <p xmlns="http://www.w3.org/1999/xhtml" title={label} style="font-size:9px; overflow: hidden; text-overflow: ellipsis;">
            <%= label %>
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end

  def funnel_bar_value_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "ylabelsvalues")} class="chart-y-labels" width="10%" height="92%" y="0" x="90%"  overflow="visible">
      <%= for %{full_bar_value: value, full_bar_percentage: percentage, offset: bar_offset, bar_height: bar_height} <- @bars do %>
        <foreignObject x="0" y={"#{bar_offset}%"} height={"#{bar_height}%"} width="100%">
          <p xmlns="http://www.w3.org/1999/xhtml" title={value} style="font-size:9px; overflow: hidden; text-overflow: ellipsis;">
            <%= value %> / <%= Float.round(percentage, 2) %>%
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end

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

  def funnel_chart_graph(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "results")} class="chart-results" width="100%" height="96%" x="0%" y="2%">
      <%= for %{sections: sections} <- @columns do %>
        <%= for %{label: label, fill_color: fill_color, y_points: [y_bottom, y_top, y_right_top, y_right_bottom], x_points: [x_left, x_middle, x_right]} <- sections do %>
          <g class="chart-bar">
            <path
              d={"M#{x_left},#{y_bottom} L#{x_left},#{y_top} C#{x_middle},#{y_top},#{x_middle},#{y_right_top},#{x_right},#{y_right_top} L#{x_right},#{y_right_bottom} C#{x_middle},#{y_right_bottom},#{x_middle},#{y_bottom},#{x_left},#{y_bottom}z"}
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

  def funnel_chart_value_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "xlabelsvalues")} class="chart-x-labels" width="90.5%" height="8%" y="0" x="0" overflow="visible">
      <%= for %{full_bar_value: value, label: label, full_bar_percentage: percentage, offset: bar_offset, width: bar_width} <- @columns do %>
        <foreignObject y="20%" x={"#{bar_offset}%"} width={"#{bar_width}%"} height="100%"  overflow="visible">
          <p xmlns="http://www.w3.org/1999/xhtml" title={label} style="font-size:9px; text-align: left; padding: 0 10% 0 0; overflow: hidden; text-overflow: ellipsis;">
            <%= value %> / <%= Float.round(percentage, 2) %>%
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end

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

  def funnel_chart_graph(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "results")} class="chart-results" width="100%" height="96%" x="0%" y="2%">
      <%= for %{sections: sections} <- @columns do %>
        <%= for %{label: label, fill_color: fill_color, y_points: [y_bottom, y_top, y_right_top, y_right_bottom], x_points: [x_left, x_middle, x_right]} <- sections do %>
          <g class="chart-bar">
            <path
              d={"M#{x_left},#{y_bottom} L#{x_left},#{y_top} C#{x_middle},#{y_top},#{x_middle},#{y_right_top},#{x_right},#{y_right_top} L#{x_right},#{y_right_bottom} C#{x_middle},#{y_right_bottom},#{x_middle},#{y_bottom},#{x_left},#{y_bottom}z"}
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

  def funnel_chart_value_labels(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "xlabelsvalues")} class="chart-x-labels" width="90.5%" height="8%" y="0" x="0" overflow="visible">
      <%= for %{full_bar_value: value, label: label, full_bar_percentage: percentage, offset: bar_offset, width: bar_width} <- @columns do %>
        <foreignObject y="20%" x={"#{bar_offset}%"} width={"#{bar_width}%"} height="100%"  overflow="visible">
          <p xmlns="http://www.w3.org/1999/xhtml" title={label} style="font-size:9px; text-align: left; padding: 0 10% 0 0; overflow: hidden; text-overflow: ellipsis;">
            <%= value %> / <%= Float.round(percentage, 2) %>%
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end

  def funnel_x_axis(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "xlabels")} class="chart-x-labels" width="90.5%" height="8%" y="92%" x="0" overflow="visible">
      <%= for %{label: label, width: width, offset: offset} <- @columns do %>
        <foreignObject y="20%" x={"#{offset}%"} width={"#{width}%"} height="100%"  overflow="visible">
          <p xmlns="http://www.w3.org/1999/xhtml" title={label} style="font-size:9px; text-align: left; padding: 0 10% 0 0; overflow: hidden; text-overflow: ellipsis;">
            <%= label %>
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end

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

  def y_axis(assigns) do
    ~H"""
    <svg id={svg_id(@chart, "ylabels")} class="chart-y-labels" width="10%" height="90%" y="0" x="0" overflow="visible">
      <%= for grid_line <- @grid_lines do %>
        <foreignObject x="0" y={"#{@offsetter.(grid_line)}%"} height="20px" width="100%"  overflow="visible">
          <p xmlns="http://www.w3.org/1999/xhtml" title={grid_line} style="font-size: 9px; padding-bottom:20%; overflow:hidden; text-overflow: ellipsis;">
            <%= grid_line %>
          </p>
        </foreignObject>
      <% end %>
    </svg>
    """
  end

end
