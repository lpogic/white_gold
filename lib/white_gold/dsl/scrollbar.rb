require_relative 'widget'
require_relative 'signal/signal_u_int'

module Tgui
  class Scrollbar < Widget

    abi_enum "Policy", :auto, :always, :never

    abi_attr :max, Integer, :maximum
    abi_attr :value, Integer
    abi_attr :viewport_size, Integer
    abi_attr :speed, Integer, :scroll_amount
    abi_attr :auto_hide?
    abi_attr :vertical?, Boolean, :vertical_scroll

    def horizontal=(horizontal)
      self.vertical = !horizontal
    end

    def horizontal?
      !vertical?
    end

    abi_def :default_width, :get_, nil => Float
    abi_signal :on_value_change, SignalUInt
    
  end
end