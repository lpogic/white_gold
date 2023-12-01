require_relative 'widget'

module Tgui
  class SubwidgetContainer < Widget

    abi_def :container, :get_, nil => Widget
    
  end
end