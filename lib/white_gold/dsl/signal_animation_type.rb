require_relative 'signal'

class Tgui
  class SignalAnimationType < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT]) do |animation_type|
        b.(AnimationType[animation_type])
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end