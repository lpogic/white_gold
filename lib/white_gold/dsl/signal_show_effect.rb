require_relative 'signal'

class Tgui
  class SignalShowEffect < Signal
    def connect &b
      block_caller = Fiddle::Closure::BlockCaller.new(0, [Fiddle::TYPE_INT, Fiddle::TYPE_INT]) do |show_effect_type, shown|
        b.(ShowEffectType[int], shown.odd?)
      end
      id = Private.connect(@pointer, block_caller)
      @@callback_storage[id] = block_caller
      return id
    end
  end
end