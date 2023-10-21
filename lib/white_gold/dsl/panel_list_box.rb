require_relative 'scrollable_panel'

module Tgui
  class PanelListBox < ScrollablePanel
    def item id: "", index: -1, **na, &b
      item = Panel.new pointer: add_item(id, index)
      bang_nest item, **na, &b
    end
  end
end