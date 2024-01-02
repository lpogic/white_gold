require_relative '../../dsl/color'

class ColorAttribute
  def initialize name, value
    @name = name
    @value = Color.from *value
  end

  attr :name
  attr :value

  def to_theme
    "#{name} = #{value.to_s};"
  end
end