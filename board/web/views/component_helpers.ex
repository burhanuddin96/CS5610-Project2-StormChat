defmodule Board.ComponentHelpers do
  def component(template_name, assigns) do
    Board.ComponentView.render(template_name, assigns)
  end
end
