require_relative 'clickable_widget'

module Tgui
  class ButtonBase < ClickableWidget

    def abi_pack_text_position_vector o
      "(#{abi_pack_float o[0]},#{abi_pack_float o[1]})"
    end

    abi_attr :text, String
    abi_def :text_position=, [:abi_pack_text_position_vector, :abi_pack_text_position_vector] => nil

    abi_render_attr :borders, Outline
    abi_render_attr :text_color, Color
    abi_render_attr :text_color_down, Color
    abi_render_attr :text_color_hover, Color
    abi_render_attr :text_color_down_hover, Color
    abi_render_attr :text_color_disabled, Color
    abi_render_attr :text_color_down_disabled, Color
    abi_render_attr :border_radius, Float, :rounded_border_radius
    
  end
end