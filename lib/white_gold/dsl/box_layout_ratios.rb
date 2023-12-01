require_relative 'box_layout'

module Tgui
  class BoxLayoutRatios < BoxLayout

    abi_def :space, :add_space,  Float => nil
    abi_def :space_at, :insert_space, [Integer, Float] => nil

    api_child :ratio=
    api_child :ratio, :get_
    
  end
end