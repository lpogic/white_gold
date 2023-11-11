require_relative 'widget'

module Tgui
  class SubwidgetContainer < Widget

    def container
      cast_up _abi_get_container
    end
    
  end
end