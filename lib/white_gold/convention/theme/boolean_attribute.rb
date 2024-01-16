module Tgui
  class BooleanAttribute
    def initialize name, value
      @name = name
      @value = value[0]
    end

    attr :name
    attr :value

    def to_theme
      "#{name} = #{value};"
    end
  end
end