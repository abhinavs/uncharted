defmodule UnchartedPhoenix.SharedEvents do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      use Phoenix.LiveView

      def mount(socket) do
        {:ok, assign(socket, :show_table, false)}
      end

      def handle_event("show_table", _, socket) do
        {:noreply, assign(socket, :show_table, true)}
      end

      def handle_event("hide_table", _, socket) do
        {:noreply, assign(socket, :show_table, false)}
      end

      # def render(%{chart: %{dataset: dataset}} = assigns) do
      #   Phoenix.LiveView.render(
      #     UnchartedPhoenix.ComponentView,
      #     "live#{chart_name(dataset)}.html",
      #     assigns
      #   )
      # end

      defp chart_name(dataset) do
        Atom.to_string(dataset.__struct__)
        |> String.replace(~r/Elixir.Uncharted.|Plot|Chart|.Dataset/, "")
        |> String.replace(~r/[A-Z]/, "_\\0")
        |> String.downcase()
      end

      defp shared_update(socket, assigns) do
        socket
        |> assign(:chart, assigns.chart)
        |> assign(:always_show_table, assigns.always_show_table)
      end
    end
  end
end
