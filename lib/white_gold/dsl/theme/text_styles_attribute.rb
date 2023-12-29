class TextStylesAttribute
  def initialize name, value
    @name = name
    @value = value
  end

  attr :name
  attr :value

  def to_theme
    "#{name} = #{value.to_s};"
  end
end