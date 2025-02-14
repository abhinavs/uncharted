defmodule UnchartedPhoenix.Components.ColorDefs do
  use Phoenix.Component
  alias Uncharted.Chart

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
end
