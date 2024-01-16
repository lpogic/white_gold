require_relative '../../abi/extern_object'

module Tgui
  class TextStylesAttribute
    def initialize name, value
      @name = name
      @value = Array(value).map do |style|
        raise "Invalid style #{style}" if !ExternObject::TextStyles[style]
        style.to_s.upcase
      end.join("|")
    end

    attr :name
    attr :value

    def to_theme
      "#{name} = #{value};"
    end
  end
end