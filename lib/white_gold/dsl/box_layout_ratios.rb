require_relative 'box_layout'

module Tgui
  class BoxLayoutRatios < BoxLayout

    abi_alias :space, :add_space
    abi_alias :space_at, :insert_space

    api_child :ratio=, :set_ratio
    api_child :ratio, :get_
  end
end