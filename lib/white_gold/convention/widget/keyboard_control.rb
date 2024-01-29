require_relative '../../dsl/custom_widget'

module Tgui
  class KeyboardControl < CustomWidget

    api_attr :key_press_listeners do
      {}
    end

    def initialized
      self.self_can_gain_focus = proc do
        1
      end

      self.self_key_press = proc do |key, alt, control, shift, system|
        key_symbol = KeyCode[key]
        self.key_press_listeners[key_symbol]&.each do |listener|
          listener.call(key_symbol, alt, control, shift, system)
        end
      end
    end

    def! :on_key do |*keys, &b|
      keys.each do |k|
        (self.key_press_listeners[k] ||= []) << b
      end
    end

  end
end