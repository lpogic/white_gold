require_relative '../../dsl/outline'

module Tgui
  class OutlineAttribute
    def initialize name, value
      @name = name
      @value = Outline.from *value
    end

    attr :name
    attr :value

    def to_theme
      "#{name} = #{value.to_s};"
    end
  end
end