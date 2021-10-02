defmodule Uncharted.StackedColumnChart.Dataset do
  @moduledoc """
  Struct representing a dataset for a basic column chart.
  """
  defstruct [:axes, :data, :sections]

  @type t() :: %__MODULE__{
          axes: Uncharted.Axes.BaseAxes.t(),
          data: list(Uncharted.BaseDatum.t()),
          sections: list(Uncharted.StackedColumnChart.Section.t())
        }
end
