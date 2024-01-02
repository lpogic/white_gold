require_relative 'container'

module Tgui
  class Group < Container

    class Theme < Widget::Theme
      theme_attr :padding, :outline
    end

  end
end