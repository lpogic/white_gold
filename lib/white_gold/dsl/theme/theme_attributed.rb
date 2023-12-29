require_relative '../color'
require_relative '../outline'
require_relative '../texture'
require_relative 'boolean_attribute'
require_relative 'color_attribute'
require_relative 'float_attribute'
require_relative 'outline_attribute'
require_relative 'text_styles_attribute'
require_relative 'texture_attribute'

module Tgui
  module ThemeAttributed
    include BangDef

    ATTRIBUTE_TYPES = {
      boolean: BooleanAttribute,
      color: ColorAttribute,
      float: FloatAttribute,
      outline: OutlineAttribute,
      text_styles: TextStylesAttribute,
      texture: TextureAttribute,
    }.freeze

    def theme_attr name, type
      attr_name = name.to_s.pascalcase
      attr_type = ATTRIBUTE_TYPES[type]
      def! name do |*value|
        @attributes[attr_name] = attr_type.new attr_name, value
      end

      if self < ThemeComponent
        self.defined_attributes(true)[name] = type
      end
    end

    def theme_comp name, type, custom_attr_name = nil
      attr_name = custom_attr_name || name.to_s.pascalcase
      def! name do |custom_name = nil, **na, &b|
        a_name = custom_name || attr_name
        comp = @attributes[a_name] ||= type.new a_name
        upon! comp, **na, &b
      end
    end
  end
end