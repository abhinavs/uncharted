defmodule LiveChartWeb.LiveLineComponent do
  @moduledoc """
  Line Chart Component
  """

  use Phoenix.LiveComponent

  def update(assigns, socket) do
    # y_axis = assigns.chart.dataset.axes.y
    # # Hardcode the number of steps to take as 5 for now
    # grid_lines = y_axis.grid_lines.({y_axis.min, y_axis.max}, 5)
    # grid_line_offsetter = fn grid_line -> 100 * (y_axis.max - grid_line) / y_axis.max end

    socket =
      socket
      |> assign(:chart, assigns.chart)
      |> assign(:points, LiveChart.LineChart.points(assigns.chart))

    # |> assign(:y_grid_lines, grid_lines)
    # |> assign(:y_grid_line_offsetter, grid_line_offsetter)

    {:ok, socket}
  end

  def render(assigns) do
    Phoenix.View.render(LiveChartWeb.ComponentView, "live_line.html", assigns)
  end
end
