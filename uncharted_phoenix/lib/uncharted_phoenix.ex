defmodule UnchartedPhoenix do
  alias Uncharted.Component
  import Phoenix.LiveView.Helpers
  @moduledoc false

  def render(_socket, chart) do
    live_component(Component.for_dataset(chart),
      chart: chart,
      always_show_table: chart.show_table,
      id: Component.id(chart)
    )
  end
end
