defmodule UnchartedPhoenix.LiveProgressComponent do
  @moduledoc """
  Bar Progress Component
  """

  use Phoenix.LiveComponent
  use UnchartedPhoenix.SharedEvents
  import UnchartedPhoenix.Components.ComponentHelpers
  alias Uncharted.Chart
  alias Uncharted.ProgressChart

  def update(assigns, socket) do
    socket =
      socket
      |> shared_update(assigns)
      |> assign(:data, ProgressChart.data(assigns.chart))
      |> assign(:progress, ProgressChart.progress(assigns.chart))

    {:ok, socket}
  end
end
