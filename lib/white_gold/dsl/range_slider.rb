require_relative 'widget'
require_relative 'slider'
require_relative 'signal/signal_range'

module Tgui
  class RangeSlider < Widget

    class Theme < Slider::Theme
      theme_attr :selected_track_color, :color
      theme_attr :selected_track_color_hover, :color
      theme_attr :texture_selected_track, :texture
      theme_attr :texture_selected_track_hover, :texture
    end

    abi_attr :min, Float, :minimum
    abi_attr :max, Float, :maximum
    abi_attr :selection_start, Float
    abi_attr :selection_end, Float
    abi_attr :step, Float
    abi_signal :on_range_change, SignalRange
    
  end
end