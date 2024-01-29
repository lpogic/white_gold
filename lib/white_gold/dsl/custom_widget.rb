require_relative 'widget'

module Tgui
  class CustomWidget < Widget

    api_attr :callbacks do
      {}
    end

    def self_key_press=(value)
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_INT, Fiddle::TYPE_INT], &value)
      _abi_impl_key_pressed block_caller
      self.callbacks[:self_key_press] = block_caller
    end

    def self_can_gain_focus=(value)
      block_caller = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [0], &value)
      _abi_impl_can_gain_focus block_caller
      self.callbacks[:self_can_gain_focus] = block_caller
    end

    def self_focus_changed=(value)
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT], &value)
      _abi_impl_focus_changed block_caller
      self.callbacks[:self_focus_changed] = block_caller
    end
  end
end