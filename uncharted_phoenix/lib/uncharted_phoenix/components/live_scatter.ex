defmodule UnchartedPhoenix.LiveScatterComponent do
  @moduledoc """
  Line Chart Component
  """

  use Phoenix.LiveComponent
  use UnchartedPhoenix.SharedEvents
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.ProgressChart
  alias Uncharted.Chart
  alias Uncharted.ScatterPlot.Point, as: ScatterPoint

  def update(assigns, socket) do
    x_axis = assigns.chart.dataset.axes.x
    y_axis = assigns.chart.dataset.axes.y
    # Hardcode the number of steps to take as 5 for now
    x_grid_lines = x_axis.grid_lines.({x_axis.min, x_axis.max}, 5)
    x_grid_line_offsetter = fn grid_line -> 100 * grid_line / x_axis.max end

    y_grid_lines = y_axis.grid_lines.({y_axis.min, y_axis.max}, 5)
    y_grid_line_offsetter = fn grid_line -> 100 * (y_axis.max - grid_line) / y_axis.max end

    socket =
      socket
      |> shared_update(assigns)
      |> assign(:points, Uncharted.ScatterPlot.points(assigns.chart))
      |> assign(:x_grid_lines, x_grid_lines)
      |> assign(:x_grid_line_offsetter, x_grid_line_offsetter)
      |> assign(:x_axis, x_axis)
      |> assign(:y_grid_lines, y_grid_lines)
      |> assign(:y_grid_line_offsetter, y_grid_line_offsetter)
      |> assign(:y_axis, y_axis)
      |> assign(:show_gridlines, assigns.chart.dataset.axes.show_gridlines)
      |> assign(:width, assigns.chart.width || 700)
      |> assign(:height, assigns.chart.height || 400)

    {:ok, socket}
  end
end
