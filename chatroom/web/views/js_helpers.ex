defmodule Faster.JSHelpers do
    import Phoenix.HTML.Tag
    def teleport(vars \\ []), do:
      tag(:div, [{:id, :from_phoenix} | vars])
end
