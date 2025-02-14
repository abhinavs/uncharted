defmodule UnchartedPhoenix.LiveBarComponent do
  @moduledoc """
  Bar Chart Component
  """

  use Phoenix.LiveComponent
  use UnchartedPhoenix.SharedEvents
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.Chart
  alias UnchartedPhoenix.Components.BarGridLineLabels
  alias UnchartedPhoenix.Components.BarGridLines
  alias UnchartedPhoenix.Components.BarGridLabels

  def update(assigns, socket) do
    x_axis = assigns.chart.dataset.axes.magnitude_axis
    # Hardcode the number of steps to take as 10 for now
    grid_lines = x_axis.grid_lines.({x_axis.min, x_axis.max}, 10)

    grid_line_offsetter = fn grid_line ->
      result = 100 * grid_line / x_axis.max
      result
    end

    socket =
      socket
      |> shared_update(assigns)
      |> assign(:bars, Uncharted.BarChart.bars(assigns.chart))
      |> assign(:grid_lines, grid_lines)
      |> assign(:offsetter, grid_line_offsetter)
      |> assign(:axis, x_axis)
      |> assign(:width, assigns.chart.width || 600)
      |> assign(:height, assigns.chart.height || 400)

    {:ok, socket}
  end
end
