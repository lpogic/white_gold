require_relative '../../dsl/texture'

class TextureAttribute
  def initialize name, value
    @name = name
    @value = Texture.from *value
  end

  attr :name
  attr :value

  def to_theme
    "#{name} = #{value.to_theme};"
  end

  def self.base_class
    Texture
  end
end