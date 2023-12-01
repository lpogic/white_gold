require_relative '../abi/extern_object'

module Tgui
  class ToolTip < ExternObject
    extend Packer

    attr_accessor :page

    abi_static :initial_delay=, :set_
    abi_static :initial_delay, :get_
    abi_static :distance_to_mouse=, :set_
    
    def self.distance_to_mouse
      abi_unpack_vector2f _abi_get_distance_to_mouse
    end

    abi_static :show_on_disabled=, :set_show_on_disabled_widgets
    abi_static :show_on_disabled?, :get_show_on_disabled_widgets

  end
end