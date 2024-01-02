require_relative 'clickable_widget'

module Tgui
  class SeparatorLine < ClickableWidget

    class Theme < Widget::Theme
      theme_attr :color, :color
    end
    
  end
end