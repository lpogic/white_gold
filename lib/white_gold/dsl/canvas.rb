require_relative 'clickable_widget'

module Tgui
  class Canvas < ClickableWidget

    class Draw < WidgetLike

      def! :fill do |*color|
        host._abi_clear host.abi_pack(Color, *color)
      end

      def! :rectangle do |**na, &b|
        shape = RectangleShape.new.send! **na, &b
        host._abi_draw shape
      end

      def! :circle do |**na, &b|
        shape = CircleShape.new.send! **na, &b
        host._abi_draw shape
      end

      def! :convex do |**na, &b|
        shape = ConvexShape.new.send! **na, &b
        host._abi_draw shape
      end

      def! :text do |**na, &b|
        text = Text.new.send! **na, &b
        host._abi_draw text
      end

    end

    def! :draw do |&b|
      Draw.new(self, nil).send! &b
      _abi_display
    end

  end
end