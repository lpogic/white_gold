require_relative 'clickable_widget'

module Tgui
  class ButtonBase < ClickableWidget

    def abi_pack_text_position_vector o
      "(#{abi_pack_float o[0]},#{abi_pack_float o[1]})"
    end

    abi_attr :text, String
    abi_def :text_position=, [:abi_pack_text_position_vector, :abi_pack_text_position_vector] => nil
    
  end
end